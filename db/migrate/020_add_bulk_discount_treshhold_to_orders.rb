class AddBulkDiscountTreshholdToOrders < ActiveRecord::Migration[5.2]
  def self.up
    add_column :orders, :bulk_discount_treshold, :integer, default: 300
  end

  def self.down
    remove_column :orders, :bulk_discount_treshold
  end
end
