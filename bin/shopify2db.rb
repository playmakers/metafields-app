#!/usr/bin/env rails runner

ShopifyAPI::Session.setup({:api_key => ENV['SHOPIFY_APP_API_KEY'], :secret => ENV['SHOPIFY_APP_SECRET']})
session = ShopifyAPI::Session.new(ENV['SHOP'].dup, ENV['TOKEN'].dup)
ShopifyAPI::Base.activate_session(session)

a = %w(259070717 259067041 259068593)

ShopifyAPI::Product.all.each do |shopify_product|
  puts shopify_product.title
  service = ShopifyDbService.new(shopify_product)
  product = service.fetch_product
  product.save!
end
