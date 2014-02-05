class Variant < ActiveRecord::Base
  belongs_to :product

  def import(shopify_variant)
    self.title     = shopify_variant.title
    self.size      = shopify_variant.option1
    self.color     = shopify_variant.option2
    self.price     = (shopify_variant.price.to_f * 100).to_i
    # self.image     =
    self.quantity = shopify_variant.inventory_quantity.to_i
  end

  def taxable
    true
  end

  def requires_shipping
    true
  end

  # "inventory_management" : "shopify"
  # "inventory_policy" : "continue"
end
