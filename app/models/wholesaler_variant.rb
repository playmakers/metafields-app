class WholesalerVariant < ActiveRecord::Base
  belongs_to :wholesaler

  def mark_unavailable
    self.available = false
    self.save!
  end

  def possible_variants
    if wholesaler.product
      wholesaler.product.variants.where({
        :size  => wholesaler.class.map_size(size),
        :color => [wholesaler.class.map_color(color), nil],
        :other => [other, nil],
      })
    else
      []
    end
  end

  def set_variant_id
    if possible_variants.size == 1
      self.variant_id = possible_variants.first.id
      save!
    end
  end
end
