class AddStockQuantityToProducts < ActiveRecord::Migration[6.0]
  def self.up
    change_table :products do |t|
      t.integer :stock_quantity, default: 0
    end
  end

  def self.down
    change_table :products do |t|
      t.remove :stock_quantity
    end
  end
end
