class CreateWholesalerVariants < ActiveRecord::Migration
  def change
    create_table :wholesaler_variants do |t|
      t.integer :wholesaler_id
      t.integer :variant_id
      t.string  :size
      t.string  :color
      t.string  :other
      t.boolean :available
      t.timestamps
    end
  end
end
