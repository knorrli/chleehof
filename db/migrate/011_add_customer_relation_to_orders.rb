class AddCustomerRelationToOrders < ActiveRecord::Migration[5.1]
  def self.up
    add_column :orders, :customer_id, :integer
  end

  def self.down
    remove_column :orders, :customer_id
  end
end
