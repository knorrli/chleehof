class InventoryService

  def self.set_stock_quantities(params)
    params.each do |product_id, attributes|
      product = Product.find(product_id)

      product.update_attributes(attributes)
    end
  end
end
