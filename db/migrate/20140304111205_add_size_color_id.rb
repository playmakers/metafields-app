class AddSizeColorId < ActiveRecord::Migration
  def change
    add_column :wholesaler_variants, :size_id, :integer
    add_column :wholesaler_variants, :color_id, :integer
  end
end
