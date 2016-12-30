class OrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :product

  delegate :price, to: :product
  delegate :currency, to: :order

  validates_presence_of :amount

  validates_uniqueness_of :product_id, scope: :order

  def total_price
    amount * price
  end
end
