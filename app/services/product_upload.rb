class ProductUpload
  def self.upload(file_name)
    begin 
      file = File.open(file_name)
      table = CSV.parse(file, liberal_parsing: true)
    rescue
      return "Произошла ошибка, попробуйте выбрать другой файл (.csv)"
    end
    price_list = file_name.original_filename
    time = Time.now
    brand_col, code_col, stock_col, cost_col, name_col = ProductUpload.search_column(table[0])
    if ((-1 == brand_col) || (-1 == code_col) ||
          (-1 == stock_col) || (-1 == cost_col))
      return "Не все обязательные поля найдены (brand, code, stok, cost)"
    end
    table.drop(1).each do |row|
      product = Product.new(price_list: price_list,
                  brand:      row[brand_col],
                  code:       row[code_col],
                  stock:      row[stock_col],
                  cost:       row[cost_col],
                  name:       row[name_col])
      Product.add(product)
    end
    Product.where(price_list: price_list).where("updated_at < ?", time).destroy_all
    return 'OK'
  end
  
  def self.search_column(header)
    brand_col, code_col, stock_col, cost_col, name_col = -1
    header.each_with_index do |val, index|
      brand_col = Product::BRAND_NAMES.include?(val) ? index : brand_col
      code_col = Product::CODE_NAMES.include?(val) ? index : code_col
      stock_col = Product::STOCK_NAMES.include?(val) ? index : stock_col
      cost_col = Product::COST_NAMES.include?(val) ? index : cost_col
      name_col = Product::NAME_NAMES.include?(val) ? index : name_col
    end
    return brand_col, code_col, stock_col, cost_col, name_col
  end
end