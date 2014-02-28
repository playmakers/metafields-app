class ProductsController < ApplicationController
  include ActionController::Live

  layout 'esdk'

  before_action :local_login
  around_filter :shopify_session

  def show
    @product = Product.where(id: params[:id], shop_id: shop_id).first
  end

  def edit
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

  def update_variant_quantities
    Stream.client = response.stream

    new_quantities = WholesalerVariant.where("wholesaler_id > 60").all.map do |variant|
      if variant.wholesaler.is_a?(WholesalerForelle)
        WholesalerForelle.get_variant_quantity(variant)
      end
    end.compact

    new_quantities.map(&:update_variant_quantity)

    # Stream.write Variant.all.sum(&:update_available)

    # Product.where(:shop_id => shop_id).all.each do |product|
    #   Stream.write product.title
    #   DbShopifyService.new(product).update_variants!
    # end
  rescue => e
    Stream.write e.message
    Stream.write e.stacktrace
  ensure
    response.stream.close
  end
end
