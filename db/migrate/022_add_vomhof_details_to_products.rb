class AddVomhofDetailsToProducts < ActiveRecord::Migration[5.2]
  def self.up
    add_column :products, :vomhof_number, :string
    add_column :products, :grouping_type, :integer
    add_column :products, :grouping, :integer
  end

  def self.down
    remove_column :products, :vomhof
    remove_column :products, :grouping_type
    remove_column :products, :grouping
  end
end
