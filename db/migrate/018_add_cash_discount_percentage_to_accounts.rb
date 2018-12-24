class AddCashDiscountPercentageToAccounts < ActiveRecord::Migration[5.1]
  def self.up
    add_column :accounts, :cash_discount_percentage, :decimal, precision: 8, scale: 2, default: 3
  end

  def self.down
    remove_column :accounts, :cash_discount_percentage
  end
end
