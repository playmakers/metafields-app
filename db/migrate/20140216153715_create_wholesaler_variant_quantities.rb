class CreateWholesalerVariantQuantities < ActiveRecord::Migration
  def change
    create_table :wholesaler_variant_quantities do |t|
      t.integer :wholesaler_variant_id
      t.integer :quantity
      t.timestamps
    end
  end
end
