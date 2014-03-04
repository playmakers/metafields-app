#!/usr/bin/env rails runner

run_date = Time.now
variants = WholesalerVariant.includes(:wholesaler).where('wholesalers.type' => WholesalerForelle)
new_quantities = variants.all.map do |variant|
  WholesalerForelle.get_variant_quantity(variant, run_date)
end

new_quantities.map(&:update_variant_quantity)

Stream.write Variant.all.sum(&:update_available)

shop_id = ENV['SHOP'].split('.').first
ShopifyAPI::Session.setup({:api_key => ENV['SHOPIFY_APP_API_KEY'], :secret => ENV['SHOPIFY_APP_SECRET']})
session = ShopifyAPI::Session.new(ENV['SHOP'].dup, ENV['TOKEN'].dup)
ShopifyAPI::Base.activate_session(session)

Product.where(:shop_id => shop_id).all.each do |product|
  Stream.write product.title
  DbShopifyService.new(product).update_variants!
end
