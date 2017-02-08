class Product < ActiveRecord::Base
  has_many :order_items
  has_many :orders, through: :order_items

  has_one :photo
  accepts_nested_attributes_for :photo

  validates_presence_of :name, :price

  def self.ordered
    order(:created_at)
  end

  def to_s
    name
  end
end
