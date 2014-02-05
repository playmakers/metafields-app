class CreateFeatures < ActiveRecord::Migration
  def change
    create_table :features do |t|
      t.integer :product_id
      t.integer :order
      t.string :title
      t.string :description
      t.string :image
      t.timestamps
    end
  end
end
