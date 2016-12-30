class Order < ActiveRecord::Base
  has_many :order_items
  has_many :products, through: :order_items

  accepts_nested_attributes_for :order_items, reject_if: proc { |attr| attr[:quantity].blank? }

  def to_s
    "Bestellung #{id}"
  end

  def total_item_count
    order_items.count
  end

  def total_item_price
    order_items.sum &:price
  end

  def currency
    "CHF"
  end
end
