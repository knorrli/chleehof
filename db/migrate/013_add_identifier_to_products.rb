class AddIdentifierToProducts < ActiveRecord::Migration[5.1]
  def self.up
    add_column :products, :identifier, :string
  end

  def self.down
    remove_column :products, :identifier
  end
end
