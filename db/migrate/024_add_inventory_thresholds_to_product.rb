class AddInventoryThresholdsToProduct < ActiveRecord::Migration[6.0]
  def self.up
    change_table :products do |t|
      t.integer :inventory_threshold_notice
      t.integer :inventory_threshold_warn
    end
  end

  def self.down
    change_table :accounts do |t|
      t.remove :inventory_threshold_notice
      t.remove :inventory_threshold_warn
    end
  end
end
