# encoding: UTF-8

require 'open-uri'
require 'nokogiri'
require 'net/http'

class WholesalerForelle < Wholesaler
  COLOR_MAPPING = {
    'Black'           => 'Schwarz',
    'Black/Black'     => 'Schwarz',
    'Black/White'     => '',
    'Cardinal'        => 'Rot',
    'Clear'           => nil,
    'Maroon'          => 'Rot',
    'Scarlet'         => 'Rot',
    'Forest'          => 'Grün',
    'Met. Silver'     => 'Silber',
    'Navy'            => 'Navy-Blau',
    'Royal'           => 'Royal-Blau',
    'Met. Gold'       => 'Gold',
    'Notre Dame Gold' => 'Gold',
    'Old Gold'        => 'Gold',
    'Vegas Gold'      => 'Gold',
    'Purple'          => 'Lila',
    'White'           => 'Weiß',
    'Yellow'          => 'Gelb',
    'Orange'          => '',
    'Pink'            => '',
  }

  SIZE_MAPPING = {
    'XS'     => 'XS',
    'S'      => 'S',
    'M'      => 'M',
    'L'      => 'L',
    'XL'     => 'XL',
    'XXL'    => 'XXL',
    '3XL'    => 'XXXL',
    '6,5'    => 'US 6.5/ EUR 39',
    '7,0'    => 'US 7.0/ EUR 40',
    '7,5'    => 'US 7.5/ EUR 40.5',
    '8,0'    => 'US 8.0/ EUR 41',
    '8,5'    => 'US 8.5/ EUR 42',
    '9,0'    => 'US 9.0/ EUR 42.5',
    '9,5'    => 'US 9.5/ EUR 43',
    '10,0'   => 'US 10.0/ EUR 44',
    '10,5'   => 'US 10.5/ EUR 44.5',
    '11,0'   => 'US 11.0/ EUR 45',
    '11,5'   => 'US 11.5/ EUR 45.5',
    '12,0'   => 'US 12.0/ EUR 46',
    '12,5'   => 'US 12.5/ EUR 47',
    '13,0'   => 'US 13.0/ EUR 47.5',
    '13,5'   => 'US 13.5/ EUR 48',
    '14,0'   => 'US 14.0/ EUR 48.5',
    '14,5'   => 'US 14.5/ EUR 49',
    '15,0'   => 'US 15.0/ EUR 49.5',
    '10 3/4' => '10 3/4',
    '11 3/4' => '11 3/4',
  }

  def self.map_color(color)
    COLOR_MAPPING[color]
  end

  def self.map_size(size)
    SIZE_MAPPING[size]
  end

  def self.get_variant_quantity(wholesaler_variant)
    response = Net::HTTP.post_form(URI.parse(wholesaler_variant.wholesaler.url), {
      'page'     => 'add-to-cart',
      'quantity' => 1000,
      'size'     => wholesaler_variant.size,
      'color'    => wholesaler_variant.color,
    })
    quantity = CGI.parse(URI.parse(response["Location"]).query)["max"].first.to_i
    quantity = 0 if quantity < 0

    Stream.write "#{wholesaler_variant.wholesaler.url} #{wholesaler_variant.size} #{wholesaler_variant.color} -> #{quantity}"
    WholesalerVariantQuantity.create!({
      :wholesaler_variant_id => wholesaler_variant.id,
      :quantity              => quantity
    })
  rescue => e
    Stream.write e
    nil
  end

  def extract
    variants.each(&:mark_unavailable)
    Stream.write url

    doc    = Nokogiri::HTML(open(url))
    sizes  = doc.css('#size option')
    colors = doc.css('#color option')

    if sizes.size > 0
      sizes.each do |node|
        size      = node[:value]
        available = !node.content.include?("OUT")

        if colors.size > 0
          Stream.write " -> #{size}: #{url}"
          doc = Nokogiri::HTML(open(url + "/?x_unit=#{size}"))
          process_colors(size, doc)
        else
          update_variant(size, nil, available)
        end
      end
    elsif colors.size > 0
      colors.each do |node|
        color      = node[:value]
        available = !node.content.include?("OUT")

        update_variant(nil, color, available)
      end
    else
      update_variant(nil, nil, true)
    end
  end

  private
  def process_colors(size, doc)
    doc.css('#color option').each do |node|
      color     = node[:value]
      available = !node.content.include?("OUT")
      update_variant(size, color, available)
    end
  end

  def update_variant(size, color, available)
    pos.each do |other|
      variant = get_variant_for(size, color, other)
      variant.quantity = 1 if available
      variant.product_id = self.product_id
      variant.save!
    end
  end

  def get_variant_for(size, color, other)
    variants.where(size: size, color: color, other: other).first || variants.build(size: size, color: color, other: other)
  end

  def pos
    if self.other
      self.other.split(' ')
    else
      [nil]
    end
  end
end
