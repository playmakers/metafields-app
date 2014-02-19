class ProductsController < ApplicationController
  layout 'esdk'

  before_action :local_login
  around_filter :shopify_session

  # def show
  #   shop_id = params[:shop].split('.').first
  #   @product = Product.where(id: params[:id], shop_id: shop_id)
  # end

  def edit
    shop_id = params[:shop].split('.').first
    @product = Product.where(id: params[:id], shop_id: shop_id).first || Product.first
    # metafields = @product.metafields

    # if new_metafields = params[:metafields]
    #   metafields.each(&:destroy)

    #   metafields = Array(new_metafields).map do |namespace, metafield|
    #     metafield.map do |key, value|
    #       if value = render_value(value)
    #         @product.add_metafield(ShopifyAPI::Metafield.new({
    #           # :description => "#{namespace} #{key}",
    #           :namespace   => namespace,
    #           :key         => key,
    #           :value       => value,
    #           :value_type  => 'string'
    #         }))
    #       end
    #     end
    #   end.flatten.compact
    # end

    # @metafields = metafields.inject({}) do |hash, metafield|
    #   hash[metafield.namespace] ||= []
    #   hash[metafield.namespace] << metafield
    #   hash
    # end
  end
end
