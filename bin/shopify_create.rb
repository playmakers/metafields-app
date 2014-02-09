#!/usr/bin/env rails runner

ShopifyAPI::Session.setup({:api_key => ENV['SHOPIFY_APP_API_KEY'], :secret => ENV['SHOPIFY_APP_SECRET']})
session = ShopifyAPI::Session.new(ENV['SHOP'].dup, ENV['TOKEN'].dup)
ShopifyAPI::Base.activate_session(session)

def create(product)
   ShopifyAPI::Product.new.tap do |shopify_product|
    shopify_product.title        = product.title
    shopify_product.body_html    = product.description
    shopify_product.product_type = product.type
    shopify_product.vendor       = product.vendor
    shopify_product.handle       = product.handle
    shopify_product.tags         = product.tags.map(&:name).join(",")
    shopify_product.published    = false

    shopify_product.options = []
    if option = product.option1
      shopify_product.options << ShopifyAPI::Option.new(name: option)
    end

    if option = product.option2
      shopify_product.options << ShopifyAPI::Option.new(name: option)
    end

    if option = product.option3
      shopify_product.options << ShopifyAPI::Option.new(name: option)
    end

    shopify_product.variants = product.variants.map do |variant|
      ShopifyAPI::Variant.new({
        title:                variant.title,
        option1:              variant.size,
        option2:              variant.color,
        # option3:            variant.option3,
        sku:                  variant.sku,
        price:                variant.display_price,
        inventory_quantity: variant.quantity,
        taxable:              variant.taxable,
        requires_shipping:    variant.requires_shipping,
        inventory_management: variant.inventory_management,
      })
    end
  end
end

product = Product.find 3
shopify_product = create(product)
shopify_product.save!

