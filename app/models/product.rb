class Product < ActiveRecord::Base
  has_many   :variants
  has_many   :features
  has_many   :wholesalers
  belongs_to :fitting

  has_and_belongs_to_many :tags

  self.inheritance_column = :_type_disabled

  def import(shopify_product)
    self.title            = shopify_product.title
    self.description      = shopify_product.body_html
    self.type             = shopify_product.product_type
    self.vendor           = shopify_product.vendor
    self.handle           = shopify_product.handle
    self.meta_title       = ''
    self.meta_description = ''

    debugger
    exit

    self.tags = []
    shopify_product.tags.split(',').each do |tag_name|
      condition = { name: tag_name }
      self.tags << (Tag.where(condition).first || Tag.create!(condition))
    end

    self.features.destroy_all
    shopify_product.metafields.select { |n| n.namespace == 'features' }.each do |feature|
      image, title, description = feature.value.split('|')
      self.features << Feature.new({
        order:       feature.key.split('_').last,
        title:       title,
        description: description,
        image:       image,
      })
    end

    f1, f2 = shopify_product.metafields.select { |n| n.namespace == 'fitting' }.sort { |a,b| a.key <=> b.key }
    if f1
      condition = { description1: f1.value }
      self.fitting = (Fitting.where(condition).first || Fitting.create!(condition)).tap do |fitting|
        fitting.description3 = f2.value
        fitting.save!
      end
    end

    self.variants.delete_all
    shopify_product.variants.each do |shopify_variant|
      condition = { shopify_id: shopify_variant.id }
      self.variants << (Variant.where(condition).first || Variant.new(condition)).tap do |variant|
        variant.import(shopify_variant)
      end
    end

    self.save!
  end
end
