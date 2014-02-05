class CreateVariants < ActiveRecord::Migration
  def change
    create_table :variants do |t|
      t.integer  :product_id
      t.integer  :shopify_id
      t.string   :title
      t.string   :size
      t.string   :color
      t.integer  :price
      t.integer  :quantity
      t.string   :image
      t.timestamps
    end
  end
end
