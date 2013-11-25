class ProductsController < ApplicationController

  before_action :local_login
  around_filter :shopify_session

  def show
    @products = ShopifyAPI::Product.find(:all, :params => {
      :collection_id => 13340861
    })
  end

  def metafields
    id = params[:id]
    @product = ShopifyAPI::Product.find(id, :params => { :fields => [:id, :title, :vendor].join(',') })
    metafields = @product.metafields

    if new_metafields = params[:metafields]
      metafields.each(&:destroy)

      metafields = Array(new_metafields).map do |namespace, metafield|
        metafield.map do |key, value|
          if value.present?
            @product.add_metafield(ShopifyAPI::Metafield.new({
              # :description => "#{namespace} #{key}",
              :namespace   => namespace,
              :key         => key,
              :value       => Array(value).join('|'),
              :value_type  => 'string'
            }))
          end
        end
      end.flatten.compact
    end

    @metafields = metafields.inject({}) do |hash, metafield|
      hash[metafield.namespace] ||= []
      hash[metafield.namespace] << metafield
      hash
    end
  end
end
