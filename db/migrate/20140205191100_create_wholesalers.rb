class CreateWholesalers < ActiveRecord::Migration
  def change
    create_table :wholesalers do |t|
      t.string  :type
      t.integer :product_id
      t.string  :url
      t.string  :other
      t.timestamps
    end
  end
end
