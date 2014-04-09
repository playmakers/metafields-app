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
    '6,5'    => '6.5/39',
    '7,0'    => '7.0/40',
    '7,5'    => '7.5/40.5',
    '8,0'    => '8.0/41',
    '8,5'    => '8.5/42',
    '9,0'    => '9.0/42.5',
    '9,5'    => '9.5/43',
    '10,0'   => '10.0/44',
    '10,5'   => '10.5/44.5',
    '11,0'   => '11.0/45',
    '11,5'   => '11.5/45.5',
    '12,0'   => '12.0/46',
    '12,5'   => '12.5/47',
    '13,0'   => '13.0/47.5',
    '13,5'   => '13.5/48',
    '14,0'   => '14.0/48.5',
    '14,5'   => '14.5/49',
    '15,0'   => '15.0/49.5',
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

    def get_variant_quantity(wholesaler_variant, run_date = nil)
      url = wholesaler_variant.wholesaler.url
      response = Net::HTTP.post_form(URI.parse(url), {
        'form_page'  => 'add_product',
        'amount'     => 1000,
        'product_id' => get_product_id(url),
        'sizes'      => wholesaler_variant.size_id,
        'colors'     => wholesaler_variant.color_id,
      })

      if match = response.body.match(/maximum of (-?\d*) pieces/)
        quantity = match[1].to_i

        Stream.write "#{url} #{wholesaler_variant} -> #{quantity}"

        WholesalerVariantQuantity.create!({
          :wholesaler_variant_id => wholesaler_variant.id,
          :quantity              => quantity,
          :created_at            => run_date,
        })
      else
        raise "no quantity found for #{url} #{wholesaler_variant}"
      end

    rescue => e
      Stream.write e
      nil
    end

    def get_product_id(url)
      url.split('/').last
    end
  end

  def extract
    Stream.write url

    doc    = Nokogiri::HTML(open(url))
    sizes  = doc.css('.sizes .item')
    colors = doc.css('.colors .item')

    if sizes.size > 0
      sizes.each do |size_node|
        size = size_of(size_node)

        colors = doc.css(".colors .option_item_#{size.last}")

        if colors.size > 0
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
  def update_variant(size, color)
    positions.each do |position|
      variant = get_variant_for(size, color, position)
      variant.product_id = self.product_id
      variant.size_id    = Array(size).last
      variant.color_id   = Array(color).last
      variant.save!
      Stream.write " -> #{size} #{color} #{position}"
    end
  end

  def get_variant_for(size, color, other)
    args = {
      size:  Array(size).first,
      color: Array(color).first,
      other: other,
    }
    variants.where(args).first || variants.build(args)
  end

  def positions
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
      node.attributes["title"].value.gsub(' - Out of stock', ''),
      node.css("input").first.attributes["value"].value,
    ]
  end
end
