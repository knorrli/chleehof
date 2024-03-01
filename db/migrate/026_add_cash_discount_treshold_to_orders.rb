class AddCashDiscountTresholdToOrders < ActiveRecord::Migration[6.0]
  def self.up
    add_column :orders, :cash_discount_treshold, :integer, default: 0
  end

  def self.down
    remove_column :orders, :cash_discount_treshold
  end
end
