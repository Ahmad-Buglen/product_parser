class ProductAdd
  def self.add(new_product)
    if (new_product.price_list.blank? || new_product.brand.blank? || new_product.cost.blank?
      new_product.code.blank? || new_product.stock.blank?)
      return
    end
    product = Product.where(price_list: new_product.price_list).where('lower(brand) = ?', 
          new_product.brand.downcase).where('lower(code) = ?', new_product.code.downcase).last
    if (product.blank?)
      product = Product.new(new_product.attributes)
    else
      product.stock = new_product.code
      product.cost = new_product.cost
      product.stock = new_product.name
      product.updated_at = Time.now
    end
    begin
      product.save
    rescue
      puts "some text for logger"
    end
  end
end
