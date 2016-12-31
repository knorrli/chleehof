class OrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :product

  delegate :price, to: :product
  delegate :currency, to: :order

  validates_presence_of :quantity
  validates_presence_of :product

  validates_uniqueness_of :product_id, scope: :order

  def to_s
    product.to_s
  end

  def total_price
    quantity * price
  end
end
