class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :url
      t.string :title
      t.text :description
      t.integer :price
      t.integer :mobile_number

      t.timestamps
    end
  end
end
