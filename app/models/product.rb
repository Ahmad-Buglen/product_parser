# frozen_string_literal: true

class Product < ApplicationRecord
  validates :price_list, :brand, :code, :stock, :cost, presence: true

  BRAND_NAMES = %w[Производитель Бренд].freeze
  CODE_NAMES = %w[Номер Артикул].freeze
  STOCK_NAMES = %w[Количество Кол-во].freeze
  COST_NAMES = %w[Цена Cтоимость].freeze
  NAME_NAMES = %w[Наименование НаименованиеТовара].freeze

  def self.add(product)
    ProductAdd.add(product)
  end
end
