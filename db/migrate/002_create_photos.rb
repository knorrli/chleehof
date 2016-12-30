include Paperclip::Schema
class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
      t.references :product
      t.attachment :picture
      t.timestamps null: false
    end
  end

  def self.down
    drop_table :photos
  end
end
