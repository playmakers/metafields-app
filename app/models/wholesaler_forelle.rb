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

  class << self
    def map_color(color)
      COLOR_MAPPING[color]
    end

    def map_size(size)
      SIZE_MAPPING[size]
    end

    def get_variant_quantity(wholesaler_variant)
      url = wholesaler_variant.wholesaler.url
      response = Net::HTTP.post_form(URI.parse(url), {
        'form_page'  => 'add_product',
        'amount'     => 1000,
        'product_id' => get_product_id(url),
        'sizes'      => wholesaler_variant.size_id,
        'colors'     => wholesaler_variant.color_id,
      })

      quantity = if match = response.body.match(/maximum of (\d+) pieces/)
        match[1].to_i
      else
        raise "no quantity found for #{wholesaler_variant.id}"
      end

      Stream.write "#{wholesaler_variant.wholesaler.url} #{wholesaler_variant.size} #{wholesaler_variant.color} -> #{quantity}"
      WholesalerVariantQuantity.create!({
        :wholesaler_variant_id => wholesaler_variant.id,
        :quantity              => quantity
      })
    rescue => e
      Stream.write e
      nil
    end

    def get_product_id(url)
      url.split('/').last
    end
  end

  def extract
    # variants.each(&:mark_unavailable)
    Stream.write url

    doc    = Nokogiri::HTML(open(url))
    sizes  = doc.css('.sizes .item')
    colors = doc.css('.colors .item')

    if sizes.size > 0
      sizes.each do |size_node|
        size = size_of(size_node)

        colors = doc.css(".colors .option_item_#{size.last}")

        if colors.size > 0
          Stream.write " -> #{size.first}: #{url}"
          colors.each do |color_node|
            color = color_of(color_node)
            update_variant(size, color)
          end
        else
          update_variant(size, nil)
        end
      end
    elsif colors.size > 0
      colors.each do |color_node|
        color = color_of(color_node)

        update_variant(nil, color)
      end
    else
      update_variant(nil, nil)
    end
  end

  private
  def update_variant(size, color, available = false)
    pos.each do |other|
      variant = get_variant_for(size, color, other)
      variant.quantity   = 1 if available
      variant.product_id = self.product_id
      variant.save!
    end
  end

  def get_variant_for(size, color, other)
    args = {
      size:     Array(size).first,
      color:    Array(color).first,
      other:    other,
      size_id:  Array(size).last,
      color_id: Array(color).last,
    }
    variants.where(args).first || variants.build(args)
  end

  def pos
    if self.other
      self.other.split(' ')
    else
      [nil]
    end
  end

  def size_of(node)
    [
      node.css(".size").first.content,
      node.css("input").first.attributes["value"].value
    ]
  end

   def color_of(node)
    [
      node.attributes["title"].value,
      node.css("input").first.attributes["value"].value
    ]
  end
end
