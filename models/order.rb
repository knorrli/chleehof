class Order < ActiveRecord::Base
  belongs_to :customer
  has_many :order_items
  has_many :products, through: :order_items

  accepts_nested_attributes_for :order_items, reject_if: proc { |attr| attr[:quantity].blank? }

  validates_presence_of :first_name, :last_name, :address_1, :zip_code, :city

  def to_s
    "Bestellung #{id}"
  end

  def name
    customer.name
  end

  def contact_info
    [first_name, last_name, phone, email].compact.join(', ')
  end

  def total_item_count
    order_items.count
  end

  def total_item_quantity
    order_items.sum &:quantity
  end

  def total_item_price
    order_items.sum &:total_price
  end

  def currency
    "CHF"
  end
end
