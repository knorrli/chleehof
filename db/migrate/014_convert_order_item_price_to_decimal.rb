class ConvertOrderItemPriceToDecimal < ActiveRecord::Migration[5.1]
  def self.up
    change_column :order_items, :price, :decimal, precision: 8, scale: 2
  end

  def self.down
    change_column :order_items, :price, :integer
  end
end
