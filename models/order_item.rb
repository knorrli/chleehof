class OrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :product

  delegate :identifier, :name, to: :product

  validates_presence_of :product, :quantity, :price

  validates_uniqueness_of :product_id, scope: :order

  def to_s
    product.to_s
  end

  def price_f(options = {})
    return nil unless price
    options[:currency] ? ("CHF %.2f" % price) : ('%.2f' % price)
  end

  def total_price
    quantity * (price || 0)
  end

  def total_price_f
    '%.2f' % total_price
  end
end
