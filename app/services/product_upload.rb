# frozen_string_literal: true

class ProductUpload
  require 'csv'
  require 'charlock_holmes'
  ERROR_FILE = 'Произошла ошибка, попробуйте выбрать другой файл (.csv) '
  ERROR_COLUMN = 'Не все обязательные поля найдены (brand, code, stok, cost)'
  ERROR_SOMETHING = 'Что-то пошло не так'

  def self.file_encode(file_name)
    begin
      content = File.read(file_name)
      detection = CharlockHolmes::EncodingDetector.detect(content)
      utf8_encoded_content = if detection[:encoding] == 'ISO-8859-1'
                               content.force_encoding('Windows-1251').encode('UTF-8')
                             else
                               CharlockHolmes::Converter.convert(content, detection[:encoding], 'UTF-8')
                             end
    rescue StandardError
      return false, ERROR_FILE
    end
    [true, utf8_encoded_content]
  end

  def self.parse_options(first_line)
    options = { liberal_parsing: true }
    options[:col_sep] = first_line.count(';') > first_line.count(',') ? ';' : ','
    columns = { brand: -1, code: -1, stock: -1, cost: -1, name: -1 }
    begin
      header = CSV.parse(first_line, options)
    rescue StandardError
      return false, ERROR_FILE
    end
    columns[:brand] = ProductUpload.search_column(header[0], Product::BRAND_NAMES)
    columns[:code] = ProductUpload.search_column(header[0], Product::CODE_NAMES)
    columns[:stock] = ProductUpload.search_column(header[0], Product::STOCK_NAMES)
    columns[:cost] = ProductUpload.search_column(header[0], Product::COST_NAMES)
    columns[:name] = ProductUpload.search_column(header[0], Product::NAME_NAMES)
    if (columns[:brand] == -1) || (columns[:code] == -1) ||
       (columns[:stock] == -1) || (columns[:cost] == -1)
      return false, ERROR_COLUMN
    end

    [true, options, columns]
  end

  def self.upload(file_name)
    valid, content = ProductUpload.file_encode(file_name)
    return content unless valid

    valid, options, columns = ProductUpload.parse_options(content.lines.first)
    return options unless valid

    price_list = file_name.original_filename
    time = Time.now
    begin
      table = CSV.parse(content, options)
      table.drop(1).each do |row|
        product = Product.new(
          price_list: price_list,
          brand: row[columns[:brand]],
          code: row[columns[:code]],
          cost: row[columns[:cost]]
        )
        product.name = columns[:name] != -1 ? row[columns[:name]] : nil
        product.stock = row[columns[:stock]][/\d+/].to_i
        Product.add(product)
      end
    rescue StandardError
      return ERROR_SOMETHING
    end
    Product.where(price_list: price_list).where('updated_at < ?', time).destroy_all
    'OK'
  end

  def self.search_column(header, names)
    header.each_with_index do |val, index|
      names.each do |name|
        return index if val.include?(name)
      end
    end
    -1
  end
end
