class CreateCustomers < ActiveRecord::Migration
  def self.up
    create_table :customers do |t|
      t.string :company
      t.string :first_name
      t.string :last_name

      t.string :address_1
      t.string :address_2
      t.string :zip_code
      t.string :city

      t.string :phone
      t.string :email
      t.boolean :pay_cash
      t.boolean :pick_up

      t.timestamps null: false
    end
  end

  def self.down
    drop_table :customers
  end
end
