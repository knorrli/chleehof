class Product < ActiveRecord::Base
  has_many :order_items
  has_many :orders, through: :order_items

  validates_presence_of :name, :price

  def self.ordered
    order(:name)
  end

  def to_s
    name
  end
end
