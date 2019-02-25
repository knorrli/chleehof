class AddCustomerAttributesToOrder < ActiveRecord::Migration[5.1]
  def self.up
    rename_column :orders, :name, :first_name
    add_column :orders, :last_name, :string
    add_column :orders, :address_1, :string
    add_column :orders, :address_2, :string
    add_column :orders, :zip_code, :string
    add_column :orders, :city, :string
    remove_column :orders, :comment
  end

  def self.down
    rename_column :orders, :first_name, :name
    remove_column :orders, :last_name
    remove_column :orders, :address_1
    remove_column :orders, :address_2
    remove_column :orders, :zip_code
    remove_column :orders, :city
    add_column :orders, :comment, :text
  end
end
