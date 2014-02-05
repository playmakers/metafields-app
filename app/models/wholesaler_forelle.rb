require 'open-uri'
require 'nokogiri'

class WholesalerForelle < Wholesaler

  def extract
    variants.each(&:mark_unavailable)

    doc   = Nokogiri::HTML(open(url))
    sizes = doc.css('#size option').map { |n| n[:value] }

    process(sizes.shift, doc)
    sizes.each do |size|
      doc = Nokogiri::HTML(open(url + "/?x_unit=#{size}"))
      process(size, doc)
    end
  end

  private
  def process(size, doc)
    doc.css('#color option').each do |node|
      variant = get_variant_for(size, node[:value])
      variant.available = !node.content.include?("OUT")
      variant.save
    end
  end

  def get_variant_for(size, color)
    variants.where(size: size, color: color).first || variants.build(size: size, color: color)
  end
end
