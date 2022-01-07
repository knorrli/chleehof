class ProductPricesService

  def self.set_product_prices(params)
    params.each do |product_id, attributes|
      product = Product.find(product_id)

      product.update_attributes(attributes)
    end
  end
end
