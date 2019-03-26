class AddCategoryToProducts < ActiveRecord::Migration[5.2]
  def self.up
    add_reference :products, :category, index: true
  end

  def self.down
    remove_reference :products, :category
  end
end
