class AddCompanyToCustomers < ActiveRecord::Migration[5.1]
  def self.up
    add_column :customers, :company, :string
  end

  def self.down
    remove_column :customers, :company
  end
end
