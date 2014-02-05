class Wholesaler < ActiveRecord::Base
  # belongs_to :product
  has_many :variants, :class_name => 'WholesalerVariant'

end
