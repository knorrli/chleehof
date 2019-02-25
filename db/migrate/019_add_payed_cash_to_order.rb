class AddPayedCashToOrder < ActiveRecord::Migration[5.1]
  def self.up
    add_column :orders, :payed_cash, :boolean, default: false
  end

  def self.down
    remove_column :orders, :payed_cash
  end
end
