class AddCashDiscountTresholdToAccounts < ActiveRecord::Migration[6.0]
  def self.up
    add_column :accounts, :cash_discount_treshold, :integer, default: 50
  end

  def self.down
    remove_column :accounts, :cash_discount_treshold
  end
end
