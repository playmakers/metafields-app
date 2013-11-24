class ProductsController < ApplicationController

  before_action :local_login
  around_filter :shopify_session

  def metafields
    id = params[:id]
    @product = ShopifyAPI::Product.find(id)

    if metafields = params[:metafields]
      @product.metafields.each(&:destroy)

      Array(metafields).each do |namespace, metafield|
        metafield.each do |key, value|
          if value.present?
            @product.add_metafield(ShopifyAPI::Metafield.new({
              # :description => "#{namespace} #{key}",
              :namespace   => namespace,
              :key         => key,
              :value       => value,
              :value_type  => 'string'
            }))
          end
        end
      end
    end

    @metafields = @product.metafields.inject({}) do |hash, metafield|
      hash[metafield.namespace] ||= []
      hash[metafield.namespace] << metafield
      hash
    end
  end

  private
  def local_login
    if ENV['SHOP'] && ENV['TOKEN']
      session[:shopify] ||= ShopifyAPI::Session.new(ENV['SHOP'].dup, ENV['TOKEN'])
    end
  end
end
