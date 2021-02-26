class CreateNewProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :price_list
      t.string :brand
      t.string :code
      t.integer :stock, default: 0, null: false
      t.decimal :cost, precision: 12, scale: 2, null: false
      t.string :name
      t.index :price_list
      t.index :brand
      t.index :code
      t.timestamps
    end
  end
end
