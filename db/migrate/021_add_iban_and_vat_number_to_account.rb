class AddIbanAndVatNumberToAccount < ActiveRecord::Migration[5.2]
  def self.up
    add_column :accounts, :vat_number, :string
    add_column :accounts, :iban, :string
  end

  def self.down
    remove_column :accounts, :vat_number
    remove_column :accounts, :iban
  end
end
