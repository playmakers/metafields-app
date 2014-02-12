# encoding: UTF-8

class Variant < ActiveRecord::Base
  belongs_to :product

  has_many :wholesaler_variants

  OPTION_MAPPING = {
    'size'   => 'size',
    'größe'  => 'size',
    'grösse' => 'size',
    'color'  => 'color',
    'farbe'  => 'color',
  }

  def self.key_for(string)
    OPTION_MAPPING[string.downcase] || 'other'
  end

  def option(number)
    key = Variant.key_for(product.option(number))
    read_attribute(key)
  end

  def set_option(key, option_value)
    write_attribute(key, option_value)
  end

  def sku
    ""
  end

  def display_price
    "%.2f" % (price / 100.0)
  end

  def display_color
    if color
      color.split('-').map(&:titlecase).join('-')
    end
  end

  def update_available
    self.quantity = if wholesaler_variants.any?
      10 * wholesaler_variants.select { |wv| wv.available }.size
    else
      3
    end
    self.save
    self.quantity
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
end

