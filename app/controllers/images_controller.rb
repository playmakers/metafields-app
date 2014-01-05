require 'open-uri'

class ImagesController < ApplicationController

  before_action :local_login, :except => 'variant'
  around_filter :shopify_session, :except => 'variant'

  def show
    @images = ShopifyAPI::Asset.find(:all)
  end

  # Usage:
  # http://localhost:3000/products/186475501/variants/426942037/image.png?url=http://cdn.shopify.com/s/files/1/0240/1531/products/Riddell_SPX10iBP_76020155-aa20-4ee7-b55c-57339ae0fbb6_compact.jpg?v=1385925477
  #
  # Route:
  # get  'products/:id/variants/:variant_id/image.:format' => 'images#variant'
  def variant
    shop       = params[:shop]
    product_id = params[:id]
    variant_id = params[:variant_id]
    image_url  = params[:url]

    begin
      url = "http://variantimages.shopifyapps.com/jquery-preload.js?shop=#{shop}&id=#{product_id}"
      content = open(url).read

      if match = content.match(/variantData = ([^;]+);/)
        variant_url      = URI(image_url)
        variant_url.path = variant_path([
          File.dirname(variant_url.path),
          JSON.parse(match[1])[variant_id]["filename"].split('.').first,
          File.basename(variant_url.path).split('_').last,
        ])
        image_url = variant_url.to_s
      end
    rescue => e
    end

    redirect_to image_url
  end

  private
  def variant_path(pieces)
    "%s/%s_%s" % pieces
  end
end
