class ImagesController < ApplicationController

  before_action :local_login
  around_filter :shopify_session

  def show
    @images = ShopifyAPI::Asset.find(:all)
  end
end
