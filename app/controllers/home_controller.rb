class HomeController < ApplicationController

  around_filter :shopify_session, :except => 'welcome'

  def index
    # get 10 products
    # @products = Product.all(find(:all, :params => {:limit => 10})
    render :layout => 'esdk'
  end

  def welcome
    current_host = "#{request.host}#{':' + request.port.to_s if request.port != 80}"
    @callback_url = "http://#{current_host}/login"
  end
end
