class ChangeProducts < ActiveRecord::Migration[6.1]
  def change
    change_column_null :products, :brand, false
    change_column_null :products, :code, false
    change_column_null :products, :price_list, false
  end
end
