#!/usr/bin/env rails runner

new_quantities = WholesalerVariant.all.map do |variant|
  WholesalerForelle.get_variant_quantity(variant)
end.compact

new_quantities.map(&:update_variant_quantity)

# # WholesalerForelle.all.each &:extract
# # puts "-------------------------------------------"
# # puts WholesalerVariant.where(:variant_id => nil).all.map(&:set_variant_id).compact.size

Stream.write "-------------------------------------------"
Stream.write Variant.all.sum &:update_available

ShopifyAPI::Session.setup({:api_key => ENV['SHOPIFY_APP_API_KEY'], :secret => ENV['SHOPIFY_APP_SECRET']})
session = ShopifyAPI::Session.new(ENV['SHOP'].dup, ENV['TOKEN'].dup)
ShopifyAPI::Base.activate_session(session)

shop_id = ENV['SHOP'].split('.').first

Product.where(:shop_id => shop_id).all.each do |product|
  Stream.write "#{product.title}"
  service = DbShopifyService.new(product)
  service.update_variants!
end
