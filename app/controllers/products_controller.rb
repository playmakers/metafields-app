class ProductsController < ApplicationController
  include ActionController::Live

  layout 'esdk'

  before_action :local_login
  # around_filter :shopify_session

  def update_variant_quantities
    Stream.client = response.stream

    Stream.write shop_id

    # Stream.write '----- Download new Quantity from Forelle -----'
    # run_date = Time.now
    # variants = WholesalerVariant.includes(:wholesaler).where('wholesalers.type' => WholesalerForelle)
    # variants.all.map do |variant|
    #   if new_quantity = WholesalerForelle.get_variant_quantity(variant, run_date)
    #     new_quantity.update_variant_quantity
    #   end
    # end

    # Stream.write '----- Update variants with new quantity ------'
    # Stream.write Variant.all.sum(&:update_available)


    # Stream.write '----- Update variants with new quantity ------'


    # Product.where(:shop_id => shop_id).all.each do |product|
    #   Stream.write product.title
    #   DbShopifyService.new(product).update_variants!
    # end
  rescue => e
    Stream.write e.message
    Stream.write e.stacktrace
  ensure
    Stream.client = nil
    response.stream.close
  end
end
