#!/usr/bin/env rails runner

WholesalerForelle.all.each &:extract

puts WholesalerVariant.all.map(&:set_variant_id).compact.size
puts Variant.all.sum &:update_available

ShopifyAPI::Session.setup({:api_key => ENV['SHOPIFY_APP_API_KEY'], :secret => ENV['SHOPIFY_APP_SECRET']})
session = ShopifyAPI::Session.new(ENV['SHOP'].dup, ENV['TOKEN'].dup)
ShopifyAPI::Base.activate_session(session)

Product.all.each do |product|
  service = DbShopifyService.new(product)
  service.update_variants!
end
