class Wholesaler < ActiveRecord::Base
  # belongs_to :product
  has_many :variants, :class_name => 'WholesalerVariant', :dependent => :destroy

  belongs_to :product

  def multiple_mapped
    sql = <<-SQL
      SELECT *, COUNT(*)  FROM wholesaler_variants
      WHERE variant_id IS NOT NULL
      GROUP BY variant_id
      HAVING COUNT(*) > 1
    SQL
  end

  def to_map
    sql = <<-SQL
      SELECT *  FROM variants v
      LEFT JOIN wholesaler_variants wv ON v.id = wv.variant_id
      WHERE wv.id IS NULL
    SQL
  end

  def unmapped
    sql = <<-SQL
      SELECT *  FROM wholesaler_variants wv
      LEFT JOIN variants v ON v.id = wv.variant_id
      WHERE v.id IS NULL
    SQL
  end

end
