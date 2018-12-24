class AddModifierAttributesToOrder < ActiveRecord::Migration[5.1]
  def self.up
    add_column :orders, :vat_percentage, :decimal, precision: 8, scale: 2
    add_column :orders, :vat_amount, :decimal, precision: 8, scale: 2
    add_column :orders, :bulk_discount, :decimal, precision: 8, scale: 2, default: 0
    add_column :orders, :spring_discount, :decimal, precision: 8, scale: 2, default: 0
    add_column :orders, :shipping_cost, :decimal, precision: 8, scale: 2, default: 0
  end

  def self.down
    remove_column :orders, :vat_percentage
    remove_column :orders, :vat_amount
    remove_column :orders, :bulk_discount
    remove_column :orders, :spring_discount
    remove_column :orders, :shipping_cost
  end
end
