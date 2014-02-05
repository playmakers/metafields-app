class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.integer  :shopify_id
      t.string   :title
      t.text     :description
      t.string   :type
      t.string   :vendor
      t.string   :handle
      t.string   :meta_title
      t.string   :meta_description
      t.integer  :fitting_id

      t.timestamps
    end
  end
end
