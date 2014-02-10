# encoding: UTF-8

class Variant < ActiveRecord::Base
  belongs_to :product

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

