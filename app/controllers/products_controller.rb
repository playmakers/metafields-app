class ProductsController < ApplicationController

  before_action :local_login
  around_filter :shopify_session

  def features
    id = params[:id]
    @product = ShopifyAPI::Product.find(id)
    @featurefields = @product.metafields.select { |metafield|
      metafield.namespace == 'features'
    }

    if features = params[:feature]
      @featurefields.each(&:destroy)

      Array(features).each_with_index do |feature, index|
        if feature.present?
          @product.add_metafield(ShopifyAPI::Metafield.new({
            :description => "Feature #{index}",
            :namespace   => 'features',
            :key         => "feature#{index}",
            :value       => feature,
            :value_type  => 'string'
          }))
        end
      end

      @featurefields = @product.metafields.select { |metafield|
        metafield.namespace == 'features'
      }
    end
  end

  private
  def local_login
    if ENV['SHOP'] && ENV['TOKEN']
      session[:shopify] ||= ShopifyAPI::Session.new(ENV['SHOP'].dup, ENV['TOKEN'])
    end
  end
end
