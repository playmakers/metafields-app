require 'open-uri'

ShopifyAPI::Session.setup({:api_key => ENV['SHOPIFY_APP_API_KEY'], :secret => ENV['SHOPIFY_APP_SECRET']})
session = ShopifyAPI::Session.new(ENV['SHOP'].dup, ENV['TOKEN'].dup)
ShopifyAPI::Base.activate_session(session)

include ProductsHelper

def render_value(value)
  if value.is_a?(Array)
    if value[1].present?
      value.join('|')
    end
  elsif value.include?(';')
    header, *body = value.split("\n")
    header = header.split(";").join('</th><th>')
    body   = body.map do |line|
      line.split(";").join('</td><td>')
    end.join('</td></tr><tr><td>')

    "<table><thead><tr><th>#{header}</th></tr></thead><tr><td>#{body}</td></tr></table>"
  elsif value.present?
    value
  end
end

defaults_hash.each do |ids, namespaces|
  Array(ids).each do |id|
    puts id
    product = ShopifyAPI::Product.find(id, :params => { :fields => [:id, :title, :vendor].join(',') })
    product.metafields.each(&:destroy)
    namespaces.each do |namespace, values|
      puts namespace
      values.each_with_index do |value, index|
        value = render_value(value)
        product.add_metafield(ShopifyAPI::Metafield.new({
          # :description => "#{namespace} #{key}",
          :namespace   => namespace,
          :key         => "#{namespace}_#{index}",
          :value       => value,
          :value_type  => 'string'
        }))
      end
    end
  end
end


def check
  doc = Nokogiri::HTML(
end


def available?(url, x_unit, y_unit)
  open("#{url}?x_unit=#{x_unit}&y_unit=#{y_unit}").read
end

size = [] # ["S", "M", "L", "XL", "XXL"]
color = [] #[, "",, , ]

COLOR_MAPPING = {
  "gelb"       => "Yellow",
  ""           => "Orange",
  ""           => "Purple",
  ""           => "Scarlet",
  ""           => "Maroon",
  "navy"       => "Navy",
  "royal-blau" => "Royal",
  "grün"       => "Forest",
  "weiß"       => "White",
  "schwarz"    => "Black",
}

products = {
  164001469 => "http://www.forelle.com/american-football/gloves/adult/nike-vapor-jet-20/12807"
}

products.map do |product_id, url|
  product = Product.find(product_id)
  product.variants.inject({}) do |hash, variant|
    size << variant.option1
    color << variant.option2

    # hash[variant.id] = available?(url, x_unit, y_unit)
    hash[variant.id] = true
    hash
  end
end
