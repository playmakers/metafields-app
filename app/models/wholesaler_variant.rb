class WholesalerVariant < ActiveRecord::Base
  belongs_to :wholesaler

  def mark_unavailable
    self.available = false
    self.save!
  end

end
