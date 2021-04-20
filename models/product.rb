class Product < ActiveRecord::Base
  has_many :order_items
  has_many :orders, through: :order_items

  validates_presence_of :name, :price

  def self.ordered
    order(:name)
  end

  def self.tracking_stock
    where(track_stock: true)
  end

  def self.search(query)
    query = query.downcase
    where('identifier LIKE ? OR lower(name) LIKE ? OR lower(name) LIKE ?', "#{query}", "%#{query} %", "%#{query}%")
  end

  def to_s
    name
  end

  def price_f(options = {})
    return nil unless price
    options[:currency] ? ("CHF %.2f" % price) : ('%.2f' % price)
  end

  def as_json(options)
    super.merge(price_f: price_f)
  end
end
