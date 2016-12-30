class CreateOrderItems < ActiveRecord::Migration
  def self.up
    create_table :order_items do |t|
      t.belongs_to :order
      t.belongs_to :product
      t.integer :amount
      t.timestamps null: false
    end
  end

  def self.down
    drop_table :order_items
  end
end
