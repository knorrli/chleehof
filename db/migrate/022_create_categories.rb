class CreateCategories < ActiveRecord::Migration[5.2]
  def self.up
    create_table :categories do |t|
      t.string :name, null: false, index: { unique: true }
      t.timestamps null: false
    end
  end

  def self.down
    drop_table :categories
  end
end
