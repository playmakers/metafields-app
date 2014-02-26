#encoding: utf-8

module ProductsHelper

  def product_variants_quantities(product)
    return [] unless product

    product.variants.map do |variant|
      data = variant.wholesaler_variants.map do |wv|
        data = wv.wholesaler_variant_quantities.order(:created_at).map do |wvq|
          [wvq.created_at.beginning_of_day.to_i * 1000, wvq.quantity]
        end
        {
          :name => "#{wv.size} #{wv.color}",
          :data => Array(data)
        }
      end
    end.flatten
  end
end
