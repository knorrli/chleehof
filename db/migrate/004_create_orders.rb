class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.string :name
      t.string :phone
      t.string :email
      t.text :comment
      t.timestamps null: false
    end
  end

  def self.down
    drop_table :orders
  end
end
