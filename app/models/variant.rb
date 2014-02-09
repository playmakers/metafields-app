# encoding: UTF-8

class Variant < ActiveRecord::Base
  belongs_to :product

  OPTION_MAPPING = {
    'size'  => 'size',
    'größe' => 'size',
    'grösse' => 'size',
    'color' => 'color',
    'farbe' => 'color',
  }

  def import(product, shopify_variant)
    self.title     = shopify_variant.title
    self.price     = (shopify_variant.price.to_f * 100).to_i
    # self.image     =
    self.quantity = shopify_variant.inventory_quantity.to_i

    if option_value = shopify_variant.option1
      key = find_key_for(product.option1)
      write_attribute(key, option_value)
    end

    if option_value = shopify_variant.option2
      key = find_key_for(product.option2)
      write_attribute(key, option_value)
    end

    if option_value = shopify_variant.option3
      key = find_key_for(product.option3)
      write_attribute(key, option_value)
    end
  end

  def sku
    ""
  end

  def display_price
    "%.2f" % (price / 100.0)
  end

  def taxable
    true
  end

  def requires_shipping
    true
  end

  def inventory_management
    "shopify"
  end

  # "inventory_policy" : "continue"

  private
  def find_key_for(string)
    OPTION_MAPPING[string.downcase] || 'other'
  end
end

