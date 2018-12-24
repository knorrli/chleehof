class AddCashDiscountToOrders < ActiveRecord::Migration[5.1]
  def self.up
    add_column :orders, :cash_discount, :decimal, precision: 8, scale: 2, default: 0
  end

  def self.down
    remove_column :orders, :cash_discount
  end
end
