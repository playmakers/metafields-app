class DbShopifyService
  attr_reader :shopify_product

  def initialize(product)
    @product         = product
    @shopify_product = begin
      ShopifyAPI::Product.find(product.id)
    rescue
      ShopifyAPI::Product.new.tap do |shopify_product|
        shopify_product.published = false
      end
    end
  end

  def new?
    @shopify_product.id.nil?
  end

  def create!
    raise "no new product" unless new?
    set_details
    set_variants
    @shopify_product.save
    update_features!
    update_fitting!
  end

  def update_all
    set_details
    update_variants!
    update_features!
    update_fitting!
  end

  def set_details
    @shopify_product.title        = @product.title
    @shopify_product.body_html    = @product.description
    @shopify_product.product_type = @product.type
    @shopify_product.vendor       = @product.vendor
    @shopify_product.handle       = @product.handle
    @shopify_product.tags         = @product.tags.map(&:name).join(",")
    @shopify_product.options      = @product.options.map { |name| ShopifyAPI::Option.new(name: name) }
    @shopify_product
  end

  def set_variants
    raise "no new product" unless new?
    @shopify_product.variants = @product.variants.map do |variant|
      shopify_variant = ShopifyAPI::Variant.new
      set_variant_details(shopify_variant, variant)
      shopify_variant
    end
  end

  def update_variants!
    raise "new product" if new?
    @product.variants.each do |variant|
      if shopify_variant = @shopify_product.variants.select { |v| v.id == variant.id }.first
        set_variant_details(shopify_variant, variant)
      else
        Stream.write "could not find variant #{variant.id}"
      end
    end
    @shopify_product.save!
  end

  def update_features!(namespace = 'features')
    delete_metafields(namespace)
    @product.features.each do |feature|
      add_metafield(namespace, feature.order, feature.value)
    end
  end

  def update_fitting!(namespace = 'fitting')
    delete_metafields(namespace)
    if @product.fitting
      add_metafield(namespace, 0, @product.fitting.description1)
      add_metafield(namespace, 1, @product.fitting.description3)
    end
  end

  private
  def set_variant_details(shopify_variant, variant)
    Stream.write "  #{variant.title} -> #{variant.quantity}"
    # shopify_variant.title                = "Variant #{variant.title}"
    shopify_variant.sku                  = variant.sku
    # shopify_variant.price                = variant.display_price
    shopify_variant.inventory_quantity   = variant.quantity
    shopify_variant.taxable              = variant.taxable
    shopify_variant.requires_shipping    = variant.requires_shipping
    shopify_variant.inventory_management = variant.inventory_management
    shopify_variant.option1              = variant.option(1) if @product.option(1)
    shopify_variant.option2              = variant.option(2) if @product.option(2)
    shopify_variant.option3              = variant.option(3) if @product.option(3)
  end

  def delete_metafields(namespace)
    Array(@shopify_product.metafields).each do |m|
      m.destroy if m.namespace == namespace
    end
  end

  def add_metafield(namespace, key, value)
    @shopify_product.add_metafield(ShopifyAPI::Metafield.new({
      # :description => "#{namespace} #{key}",
      :namespace   => namespace,
      :key         => "#{namespace}_#{key}",
      :value       => value,
      :value_type  => 'string'
    }))
  end
end
