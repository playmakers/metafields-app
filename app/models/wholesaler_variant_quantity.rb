class WholesalerVariantQuantity < ActiveRecord::Base

  belongs_to :wholesaler_variant

  def update_variant_quantity
    Stream.write "#{wholesaler_variant.id} -> #{self.quantity}"
    wholesaler_variant.quantity = self.quantity
    wholesaler_variant.save
  end
end

