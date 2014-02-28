#!/usr/bin/env rails runner

shop_id = ENV['SHOP'].split('.').first
ShopifyAPI::Session.setup({:api_key => ENV['SHOPIFY_APP_API_KEY'], :secret => ENV['SHOPIFY_APP_SECRET']})
session = ShopifyAPI::Session.new(ENV['SHOP'].dup, ENV['TOKEN'].dup)
ShopifyAPI::Base.activate_session(session)


new_quantities = WholesalerVariant.where("wholesaler_id > 60").all.map do |variant|
  if variant.wholesaler.is_a?(WholesalerForelle)
    WholesalerForelle.get_variant_quantity(variant)
  end
end.compact

new_quantities.map(&:update_variant_quantity)

Stream.write Variant.all.sum(&:update_available)

Product.where(:shop_id => shop_id).all.each do |product|
  Stream.write product.title
  DbShopifyService.new(product).update_variants!
end
