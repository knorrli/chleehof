class AddIdentifierToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :identifier, :string
  end

  def self.down
    remove_column :products, :identifier
  end
end
