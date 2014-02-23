class HomeController < ApplicationController
  include ActionController::Live

  around_filter :shopify_session, :except => [:welcome, :import]

  def index
    # get 10 products
    # @products = Product.all(find(:all, :params => {:limit => 10})
    render :layout => 'esdk'
  end

  def welcome
    current_host = "#{request.host}#{':' + request.port.to_s if request.port != 80}"
    @callback_url = "http://#{current_host}/login"
  end

  def import
    if (token = params[:token]) && (shop = params[:shop])
      shop_id = shop.split('.').first
      Stream.client = response.stream

      new_quantities = WholesalerVariant.all.map do |variant|
        WholesalerForelle.get_variant_quantity(variant)
      end.compact

      new_quantities.map(&:update_variant_quantity)

      Stream.write "-------------------------------------------"
      Stream.write Variant.all.sum &:update_available

      # ShopifyAPI::Session.setup({:api_key => ENV['SHOPIFY_APP_API_KEY'], :secret => ENV['SHOPIFY_APP_SECRET']})
      ShopifyAPI::Base.activate_session ShopifyAPI::Session.new(shop.dup, token.dup)

      Product.where(:shop_id => shop_id).all.each do |product|
        Stream.write product.title
        DbShopifyService.new(product).update_variants!
      end
    else
      Stream.write "wrong params"
    end
  rescue => e
    Stream.write e.message
  ensure
    response.stream.close
  end
end
