#!/usr/bin/env rails runner

ShopifyAPI::Session.setup({:api_key => ENV['SHOPIFY_APP_API_KEY'], :secret => ENV['SHOPIFY_APP_SECRET']})
session = ShopifyAPI::Session.new(ENV['SHOP'].dup, ENV['TOKEN'].dup)
ShopifyAPI::Base.activate_session(session)

ShopifyAPI::Product.all.each do |shopify_product|

  condition = { shopify_id: shopify_product.id }
  (Product.where(condition).first || Product.new(condition)).tap do |product|
    puts shopify_product.title
    product.import(shopify_product)
  end
end
