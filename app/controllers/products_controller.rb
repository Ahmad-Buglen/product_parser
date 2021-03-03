class ProductsController < ApplicationController
  

  def index
    @products = Product.all.order(:id)
  end

  def upload
    rezult = ProductUpload.upload(params[:file])
    if ('OK' == rezult)
      redirect_to action: "index"
    else
      render plain: rezult
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