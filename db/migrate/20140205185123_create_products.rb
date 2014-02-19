class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string   :title
      t.text     :description
      t.string   :type
      t.string   :vendor
      t.string   :handle
      t.string   :option1
      t.string   :option2
      t.string   :option3
      t.string   :meta_title
      t.string   :meta_description
      t.integer  :fitting_id
      t.string   :shop_id

      t.timestamps
    end
  end
end
