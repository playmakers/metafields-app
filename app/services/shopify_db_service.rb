class ShopifyDbService
  attr_reader :product

  def initialize(shopify_product)
    @shopify_product = shopify_product
    @product   = Product.where(id: shopify_product.id).first
    @product ||= Product.new(id: shopify_product.id)
  end

  def fetch_product
    set_details
    set_features
    set_fitting
    set_variants
    @product
  end

  def set_details
    @product.title            = @shopify_product.title
    @product.description      = @shopify_product.body_html
    @product.type             = @shopify_product.product_type
    @product.vendor           = @shopify_product.vendor
    @product.handle           = @shopify_product.handle
    options = @shopify_product.options.sort { |a,b| a.position <=> b.position }
    @product.option1          = options[0].try(&:name)
    @product.option2          = options[1].try(&:name)
    @product.option3          = options[2].try(&:name)
    @product.meta_title       = ''
    @product.meta_description = ''

    @product.tags = @shopify_product.tags.split(',').map do |tag_name|
      condition = { name: tag_name.strip }
      Tag.where(condition).first || Tag.create!(condition)
    end
  end

  def set_features
    @product.features.destroy_all
    @product.features = metafields('features').map do |feature|
      Feature.new({
        order: feature.key.split('_').last,
        value: feature.value
      })
    end
  end

  def set_fitting
    f1, f2 = metafields('fitting')
    if f1
      condition = { description1: f1.value }
      @product.fitting = (Fitting.where(condition).first || Fitting.create!(condition)).tap do |fitting|
        fitting.description3 = f2.value
        fitting.save!
      end
    end
  end

  def set_variants
    @product.variants.destroy_all
    @product.variants = @shopify_product.variants.map do |shopify_variant|
      Variant.new.tap do |variant|
        set_variant(variant, shopify_variant)
      end
    end
  end

  def set_variant(variant, shopify_variant)
    variant.id       = shopify_variant.id
    variant.title    = shopify_variant.title
    variant.price    = (shopify_variant.price.to_f * 100).to_i
    # self.image     =
    variant.quantity = shopify_variant.inventory_quantity.to_i

    if option_value  = shopify_variant.option1
      key = Variant.key_for(@product.option1)
      variant.set_option(key, option_value)
    end

    if option_value  = shopify_variant.option2
      key = Variant.key_for(@product.option2)
      variant.set_option(key, option_value)
    end

    if option_value  = shopify_variant.option3
      key = Variant.key_for(@product.option3)
      variant.set_option(key, option_value)
    end
  end


  private
  def metafields(namespace)
    @shopify_product.metafields.select { |n| n.namespace == namespace }.sort { |a,b| a.key <=> b.key }
  end
end
