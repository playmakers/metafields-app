class CreateWholesalers < ActiveRecord::Migration
  def change
    create_table :wholesalers do |t|
      t.string  :type
      t.integer :shopify_product_id
      t.string  :url
      t.timestamps
    end
  end
end
