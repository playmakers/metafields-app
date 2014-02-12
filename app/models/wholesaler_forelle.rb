# encoding: UTF-8

require 'open-uri'
require 'nokogiri'

class WholesalerForelle < Wholesaler
  COLOR_MAPPING = {
    'Black'           => 'schwarz',
    'Black/Black'     => 'schwarz',
    'Black/White'     => '',
    'Cardinal'        => 'rot',
    'Forest'          => 'grün',
    'Maroon'          => 'rot',
    'Met. Gold'       => 'gold',
    'Met. Silver'     => 'silber',
    'Navy'            => 'navy-blau',
    'Notre Dame Gold' => 'gold',
    'Old Gold'        => 'gold',
    'Orange'          => '',
    'Pink'            => 'lila',
    'Purple'          => 'lila',
    'Royal'           => 'royal-blau',
    'Scarlet'         => 'rot',
    'Vegas Gold'      => 'gold',
    'White'           => 'weiß',
    'Yellow'          => 'gelb',
  }

  SIZE_MAPPING = {
    'XS'   => 'XS',
    'S'    => 'S',
    'M'    => 'M',
    'L'    => 'L',
    'XL'   => 'XL',
    'XXL'  => 'XXL',
    '3XL'  => 'XXXL',
    '6,5'  => 'US 6.5/ EUR 39',
    '7,0'  => 'US 7.0/ EUR 40',
    '7,5'  => 'US 7.5/ EUR 40.5',
    '8,0'  => 'US 8.0/ EUR 41',
    '8,5'  => 'US 8.5/ EUR 42',
    '9,0'  => 'US 9.0/ EUR 42.5',
    '9,5'  => 'US 9.5/ EUR 43',
    '10,0' => 'US 10.0/ EUR 44',
    '10,5' => 'US 10.5/ EUR 44.5',
    '11,0' => 'US 11.0/ EUR 45',
    '11,5' => 'US 11.5/ EUR 45.5',
    '12,0' => 'US 12.0/ EUR 46',
    '12,5' => 'US 12.5/ EUR 47',
    '13,0' => 'US 13.0/ EUR 47.5',
    '13,5' => 'US 13.5/ EUR 48',
    '14,0' => 'US 14.0/ EUR 48.5',
    '14,5' => 'US 14.5/ EUR 49',
    '15,0' => 'US 15.0/ EUR 49.5',
    ''     => '10 3/4',
    ''     => '11 3/4',
  }

  def self.map_color(color)
    COLOR_MAPPING[color]
  end

  def self.map_size(size)
    SIZE_MAPPING[size]
  end

  def extract
    variants.each(&:mark_unavailable)

    doc         = Nokogiri::HTML(open(url))
    hash_colors = (doc.css('#color option').size > 0)

    doc.css('#size option').each do |node|
      size      = node[:value]
      available = !node.content.include?("OUT")

      if hash_colors
        doc = Nokogiri::HTML(open(url + "/?x_unit=#{size}"))
        process(size, doc)
      else
        update_variant(size, nil, available)
      end
    end
  end

  private
  def process(size, doc)
    doc.css('#color option').each do |node|
      color     = node[:value]
      available = !node.content.include?("OUT")
      update_variant(size, color, available)
    end
  end

  def update_variant(size, color, available)
    pos.each do |other|
      variant = get_variant_for(size, color, other)
      variant.available = available
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
