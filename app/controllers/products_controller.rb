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
      file = File.open(params[:file])
      table = CSV.parse(file, liberal_parsing: true)
    rescue
      render plain: "Произошла ошибка, попробуйте выбрать другой файл (.csv)"
      return
    end

    # date = 
    brand_col, code_col, stock_col, cost_col, name_col = search_column(table)
    save_or_update_product(table, brand_col, code_col, stock_col, cost_col, name_col)

    # delete_old_product(params[:file].original_filename)
    @products = Product.all
    render "index"
  end

  def delete_old_product(original_filename, date)

  end

  def search_column(table)
    brand_col, code_col, stock_col, cost_col, name_col = -1
    table[0].each_with_index do |val, index|
      brand_col = $brand_names.include?(val) ? index : brand_col
      code_col = $code_names.include?(val) ? index : code_col
      stock_col = $stock_names.include?(val) ? index : stock_col
      cost_col = $cost_names.include?(val) ? index : cost_col
      name_col = $name_names.include?(val) ? index : name_col
    end
    if ((-1 == brand_col) || (-1 == code_col) ||
          (-1 == stock_col) || (-1 == cost_col))
      render plain: "Не все обязательные поля найдены (brand, code, stok, cost)"
      return
    end
    return brand_col, code_col, stock_col, cost_col, name_col
  end

  def save_or_update_product(table, brand_col, code_col, stock_col, cost_col, name_col)
    table.drop(1).each do |row|
      if (row[brand_col].blank? || row[brand_col].blank? ||
            row[brand_col].blank? || row[brand_col].blank?)
        next
      end
      product = Product.find_by(price_list: params[:file].original_filename, brand: row[brand_col], code: row[code_col])
      if (product.blank?)
        product = Product.new(price_list: params[:file].original_filename,
                              brand:      row[brand_col],
                              code:       row[code_col],
                              stock:      row[stock_col],
                              cost:       row[cost_col],
                              name:       row[name_col])
      else
          product.stock = row[code_col]
          product.cost = row[cost_col]
          product.stock = row[name_col]
      end
      begin
        product.save
      rescue
        puts "some text for logger"
      end
    end
  end
end


    # .force_encoding("ISO-8859-1").encode("Windows-1251")
     # rescue
    #   file = File.open(params[:file], "r:ISO-8859-1")
    #   table = CSV.parse(file, liberal_parsing: true)
    # end

    
    # if table[0].size < 2
    #   table = CSV.parse(file, {col_sep: ';',  liberal_parsing: true})
    # end

        # "r:ISO-8859-1")
      # file = file.force_encoding("ISO-8859-1").encode("Windows-1251")
      # begin 
        # file = File.open(params[:file])
        # table = CSV.parse(file.force_encoding('UTF-8'))
      # rescue
      #   file = File.open(params[:file], "r:ISO-8859-1")
      #   table = CSV.parse(file, {col_sep: ';',  liberal_parsing: true})
      # end 

      # my_array = []

      # File.open(params[:file]).each do |line| # `foreach` instead of `open..each` does the same
        # begin     
        #   CSV.parse(line) do |row|
        #     my_array << row
        #   end
        # rescue CSV::MalformedCSVError
        #   next
        # end
      # end

# table = CSV.parse("Наименование,Производитель,Артикул,Количество,Цена,Партия,Срок поставки (дн.)
# Фильтр масляный,TOYOTA,04152YZZA1,10,311.12,1,
# Фильтр масляный,TOYOTA,04152YZZA5,10,229.00,1,
# Колодки тормозные,TOYOTA,044650K090,3,3618.22,1,", headers: true )

# Наименование,Производитель,Артикул,Количество,Цена,Партия,Срок поставки (дн.)
# Фильтр масляный,TOYOTA,04152YZZA1,10,311.12,1,
# Фильтр масляный,TOYOTA,04152YZZA5,10,229.00,1,
# Колодки тормозные,TOYOTA,044650K090,3,3618.22,1,

# "Артикул";"Бренд";"НаименованиеТовара";"ЦеноваяГруппа";"Количество";"Цена";"КратностьОтгрузки";"НаименованиеХарактеристики";"НоменклатурнаяГруппа";"Склад";"Срок";"Код1С"
# "00000001226";"";"Кабель электрический 2*1,5 для проводки прицепов (МИН 50м!)";"HD Тормозные колодки (NF parts)";">100";"84,00";"1,00";"";"";"ЦС";"0";"i-005455126"
# "TL-R01-015-01";"";"Втулка винта подъема";"";"3";"2520,00";"1,00";"";"";"ЦС";"0";"i-005460457"
# "25-3920-511";"#УДАЛИТЬ#ASPOECK";"Фонарь зад ECOLED 2XASS2 473*130 с рогом правый";"";"1";"15239,00";"1,00";"";"";"ЦС";"0";"i-005428540"
# "415";"3F QUALITY";"Фильтр салона угольный HYUNDAI Santa Fe I 2000 → 03/2003";"PC Фильтры 3F Quality";"1";"300,00";"1,00";"";"";"ЦС";"0";"i-003509555"
# "D41173C";"AUTOFREN";"Ремком.суппорта SEAT CORDOBA (6L2) 2002-2009";"PC Тормозная система (AUTOFREN)";"1";"411,00";"1,00";"";"";"ЦС";"0";"i-005401054"