class AddCompanyAttributesToOrders < ActiveRecord::Migration[5.1]
  def self.up
    add_column :orders, :company, :string
  end

  def self.down
    remove_column :orders, :company
  end
end
