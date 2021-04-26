class OrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :product

  delegate :identifier, :name, to: :product

  validates_presence_of :product, :quantity, :price

  validates_uniqueness_of :product_id, scope: :order

  after_save :update_stock
  before_destroy :restock

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

  private

  def update_stock
    if self.saved_changes[:quantity] && product.track_stock
      old_quantity = self.saved_changes[:quantity][0].to_i
      new_quantity = self.saved_changes[:quantity][1].to_i
      product.update_attributes(stock_quantity: product.stock_quantity - (new_quantity - old_quantity))
    end
  end

  def restock
    if product.track_stock
      product.update_attributes(stock_quantity: product.stock_quantity + self.attribute_in_database(:quantity))
    end
  end
end
