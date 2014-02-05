class CreateFittings < ActiveRecord::Migration
  def change
    create_table :fittings do |t|
      t.text :description1
      t.text :description2
      t.text :description3
      t.timestamps
    end
  end
end
