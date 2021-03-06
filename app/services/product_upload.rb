class ProductUpload
  require 'csv'

  require 'charlock_holmes'

  
  def self.upload(file_name)
    # begin 
      # first_line = File.open(file_name) {|f| f.readline}


      content = File.read(file_name)
      detection = CharlockHolmes::EncodingDetector.detect(content)
      utf8_encoded_content = CharlockHolmes::Converter.convert content, detection[:encoding],  'UTF-8'
      # encoded_content = content.encode("ISO-8859-1", 'UTF-8')
      # options = {liberal_parsing: true, external_encoding: 'UTF-8'}
      # Encoding.name_list.each do |encode|
      #   if first_line.force_encoding(encode).valid_encoding?
      #     options[:internal_encoding] = encode
      #     break
      #   end
      # end
      # , "r:ISO-8859-1"
      # force_encoding("ISO-8859-1")
      # return options[:internal_encoding].to_s
      # quote_chars = %w(" | ~ ^ & *) 
      # begin
      
      # if first_line.count(';') > first_line.count(',')
      #   options[:col_sep] = ';'
      # end
      # if first_line.count('"') > 7
      #   options[:quote_char] = '"'
      # end
      # header = CSV.parse(first_line, options)
      return utf8_encoded_content

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
    # return "#{header[0].inspect} 
    #  brand_col = #{brand_col}, code_col = #{code_col}, 
    #  stock_col = #{stock_col}, cost_col = #{cost_col}
    #  #{header[0][0].tr('"', '')}"
    price_list = file_name.original_filename
    time = Time.now
    file = File.open(file_name)
    table = CSV.parse(file, options)

    # return table.force_encoding(Encoding::UTF_8)
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
      # puts "debag val = #{transliterate(val.tr('"', ''))}, index = #{index}"
      names.each do |name|
        if val.include? name
          return index
        end
      end
    end
    -1
  end 

  def self.detect_charset(file_path)
    `file --mime #{file_path}`.strip.split('charset=').last
  rescue #=> e 
    # Rails.logger.warn "Unable to determine charset of #{file_path}"
    # Rails.logger.warn "Error: #{e.message}"
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