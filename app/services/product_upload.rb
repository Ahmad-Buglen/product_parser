class ProductUpload
  require 'csv'

  def self.upload(file_name)
    # begin 
      
      first_line = File.open(file_name) {|f| f.readline}
      header = CSV.parse(first_line,  {:col_sep =>";", liberal_parsing: true})

      # puts header.inspect
      brand_col = ProductUpload.search_column(header[0], Product::BRAND_NAMES)
      code_col = ProductUpload.search_column(header[0], Product::CODE_NAMES)
      stock_col = ProductUpload.search_column(header[0], Product::STOCK_NAMES)
      cost_col = ProductUpload.search_column(header[0], Product::COST_NAMES)
      name_col = ProductUpload.search_column(header[0], Product::NAME_NAMES)
      if ((-1 == brand_col) || (-1 == code_col) ||
            (-1 == stock_col) || (-1 == cost_col))

        return "Не все обязательные поля найдены (brand, code, stok, cost) 
              #{header[0].inspect}
              brand_col = #{brand_col}, code_col = #{code_col}, stock_col = #{stock_col}, cost_col = #{cost_col}" 
      end
    return "#{header[0].inspect} 
     brand_col = #{brand_col}, code_col = #{code_col}, 
     stock_col = #{stock_col}, cost_col = #{cost_col}
     #{header[0][0].tr('"', '')}"
    price_list = file_name.original_filename
    time = Time.now
    file = File.open(file_name)
    table = CSV.parse(file, {quote_char: '"', :col_sep =>";", liberal_parsing: true} )
    table.drop(1).each do |row|
      # next if (i == 0)
      product = Product.new(price_list: price_list,
                                brand:      row[brand_col],
                                code:       row[code_col],
                                cost:       row[cost_col],
                                name:       row[name_col])

        product.stock = row[stock_col][/\d+/].to_i
        Product.add(product)
        # puts row
      # ...
    end
    # return table
      # table = CSV.parse(file,  { liberal_parsing: true}) 
      
    # rescue => e
      # return "Произошла ошибка, попробуйте выбрать другой файл (.csv) " + header + e.message
    # end
    # table.drop(1).each do |row|
    # end
    Product.where(price_list: price_list).where("updated_at < ?", time).destroy_all
    return 'OK'
  end
  def self.search_column(header, names)
    puts names
    header.each_with_index do |val, index|
      puts "debag val = #{transliterate(val.tr('"', ''))}, index = #{index}"
      if names.include?(transliterate(val.tr('"', '')))
        return index
      end
    end
    -1
  end 

  # def self.search_column(header)
  #   brand_col = -1
  #   code_col = -1
  #   stock_col = -1
  #   cost_col = -1
  #   name_col = -1
  #   puts "brand_col = #{brand_col}, code_col = #{code_col}, 
  #    stock_col = #{stock_col}, cost_col = #{cost_col}, name_col = #{name_col}"
  #   header.each_with_index do |val, index|
  #     val = val.tr('"', '')
  #     brand_col = Product::BRAND_NAMES.include?(val) ? index : brand_col
  #     code_col = Product::CODE_NAMES.include?(val) ? index : code_col
  #     stock_col = Product::STOCK_NAMES.include?(val) ? index : stock_col
  #     cost_col = Product::COST_NAMES.include?(val) ? index : cost_col
  #     name_col = Product::NAME_NAMES.include?(val) ? index : name_col
  #     puts "debag index = #{index}, code_col = #{code_col}"
  #   end
  #   return brand_col, code_col, stock_col, cost_col, name_col
  # end
end


      # file = File.open(file_name)

      # quote_char: '"', 
      # field_size_limit: nil, 
      # converters: nil, 
      # unconverted_fields: nil, 
      # headers: false, 
      # return_headers: false, 
      # write_headers: nil, 
      # header_converters: nil, 
      # skip_blanks: false, 
      # force_quotes: false, 
      # skip_lines: nil, 
      # liberal_parsing: false, 
      # internal_encoding: nil, 
      # external_encoding: nil, 
      # encoding: nil, 
      # nil_value: nil,
      #  empty_value: "", 
      #  quote_empty: true, 
      #  write_converters: nil, 
      #  write_nil_value: nil, 
      #  write_empty_value: "", 
      #  strip: false

#  :encoding "UTF-32BE:UTF-8     