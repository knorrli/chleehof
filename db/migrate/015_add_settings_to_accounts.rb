class AddSettingsToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :vat_percentage, :decimal, precision: 8, scale: 2
    add_column :accounts, :bulk_discount_percentage, :decimal, precision: 8, scale: 2
    add_column :accounts, :bulk_discount_treshold, :integer
    add_column :accounts, :spring_discount_active, :boolean
    add_column :accounts, :spring_discount_percentage, :decimal, precision: 8, scale: 2
  end

  def self.down
    remove_column :accounts, :vat_percentage
    remove_column :accounts, :bulk_discount_percentage
    remove_column :accounts, :bulk_discount_treshold
    remove_column :accounts, :spring_discount_active
    remove_column :accounts, :spring_discount_percentage
  end
end
