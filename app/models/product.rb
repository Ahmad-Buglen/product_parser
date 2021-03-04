class Product < ApplicationRecord
  validates :price_list, :brand, :code, :stock, :cost,  :presence => true


  BRAND_NAMES = ['Производитель', 'Бренд']
  CODE_NAMES = ['Номер','Артикул']
  STOCK_NAMES = ['Количество', 'Кол-во']
  COST_NAMES = ['Цена']
  NAME_NAMES = ['Наименование', 'НаименованиеТовара']

  def self.add(product)
    ProductAdd.add(product)
  end
end
