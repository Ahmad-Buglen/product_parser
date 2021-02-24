class ProductsController < ApplicationController
  require 'csv'
  def index
    @products = Product.all
  end

  $brand_names = ['Производитель', 'Наименование']
  $code_names = ['Артикул', 'Номер']
  $stock_names = ['Количество', 'Кол-во']
  $cost_names = ['Цена']
  $name_names = ['Наименование', 'НаименованиеТовара']

  def upload
    begin
      table = CSV.parse(File.read(params[:file]))
    rescue
      render plain: "Произошла ошибка, попробуйте выбрать другой файл (.csv)"
      return
    end

    brand_column, code_column, stock_column, cost_column, name_column = -1
    # table[0].each_with_index do |val,index|
    #   brand_column =  $brand_names.include?(val) ? index : brand_column
    #   code_column =  $code_names.include?(val) ? index : code_column
    #   stock_column =  $stock_names.include?(val) ? index : stock_column
    #   cost_column =  $cost_names.include?(val) ? index : cost_column
    #   name_column =  $name_names.include?(val) ? index : name_column
    # end
    render plain: table #+ brand_column.to_s + code_column.to_s + stock_column.to_s + cost_column.to_s + name_column.to_s
  end


end

# table = CSV.parse("Наименование,Производитель,Артикул,Количество,Цена,Партия,Срок поставки (дн.)
# Фильтр масляный,TOYOTA,04152YZZA1,10,311.12,1,
# Фильтр масляный,TOYOTA,04152YZZA5,10,229.00,1,
# Колодки тормозные,TOYOTA,044650K090,3,3618.22,1,", headers: true )

# Наименование,Производитель,Артикул,Количество,Цена,Партия,Срок поставки (дн.)
# Фильтр масляный,TOYOTA,04152YZZA1,10,311.12,1,
# Фильтр масляный,TOYOTA,04152YZZA5,10,229.00,1,
# Колодки тормозные,TOYOTA,044650K090,3,3618.22,1,