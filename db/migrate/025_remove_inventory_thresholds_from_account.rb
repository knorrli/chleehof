class RemoveInventoryThresholdsFromAccount < ActiveRecord::Migration[6.0]
  def self.up
    change_table :accounts do |t|
      t.remove :threshold_notice
      t.remove :threshold_warn
    end
  end

  def self.down
    change_table :accounts do |t|
      t.integer :threshold_notice, default: 100
      t.integer :threshold_warn, default: 0
    end
  end
end
