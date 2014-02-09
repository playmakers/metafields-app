#!/usr/bin/env rails runner

ShopifyAPI::Session.setup({:api_key => ENV['SHOPIFY_APP_API_KEY'], :secret => ENV['SHOPIFY_APP_SECRET']})
session = ShopifyAPI::Session.new(ENV['SHOP'].dup, ENV['TOKEN'].dup)
ShopifyAPI::Base.activate_session(session)

def update(product)
  shopify_product = ShopifyAPI::Product.find(product.shopify_id)

  #### fitting
  namespace = 'features'
  shopify_product.metafields.each do |m|
    m.destroy if m.namespace == namespace
  end

  product.features.each do |feature|
    shopify_product.add_metafield(ShopifyAPI::Metafield.new({
      # :description => "#{namespace} #{key}",
      :namespace   => namespace,
      :key         => "#{namespace}_#{feature.order}",
      :value       => feature.value,
      :value_type  => 'string'
    }))
  end

  #### fitting
  namespace = 'fitting'
  shopify_product.metafields.each do |m|
    m.destroy if m.namespace == namespace
  end

  shopify_product.add_metafield(ShopifyAPI::Metafield.new({
    # :description => "#{namespace} #{key}",
    :namespace   => namespace,
    :key         => "#{namespace}_0",
    :value       => product.fitting.description1,
    :value_type  => 'string'
  }))

  shopify_product.add_metafield(ShopifyAPI::Metafield.new({
    # :description => "#{namespace} #{key}",
    :namespace   => namespace,
    :key         => "#{namespace}_1",
    :value       => product.fitting.description3,
    :value_type  => 'string'
  }))

  shopify_product
end

product = Product.find(1)
shopify_product = update(product)


__END__

  # shopify_product.title        = 'Test2'
  # shopify_product.body_html    = product.description
  # shopify_product.product_type = product.type
  # shopify_product.vendor       = product.vendor
  # shopify_product.handle       = product.handle
  # shopify_product.tags         = product.tags.map(&:name).join(",")

  # shopify_product.options = []
  # if option = product.option1
  #   shopify_product.options << ShopifyAPI::Option.new(name: option)
  # end

  # if option = product.option2
  #   shopify_product.options << ShopifyAPI::Option.new(name: option)
  # end

  # if option = product.option3
  #   shopify_product.options << ShopifyAPI::Option.new(name: option)
  # end

  # shopify_product.variants = product.variants.map do |variant|
  #   ShopifyAPI::Variant.new({
  #     # id:                 variant.id,
  #     title:                variant.title,
  #     option1:              variant.size,
  #     option2:              variant.color,
  #     # option3:            variant.option3,
  #     sku:                  variant.sku,
  #     price:                variant.display_price,
  #     inventory_quantity:   10,
  #     # inventory_quantity: variant.quantity,
  #     taxable:              variant.taxable,
  #     requires_shipping:    variant.requires_shipping,
  #     inventory_management: variant.inventory_management,
  #   # shopify_variant.prefix_options = {:product_id => shopify_product.id }
  #   # shopify_variant.save
  #   })
