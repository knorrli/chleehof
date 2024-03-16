class Order < ActiveRecord::Base
  belongs_to :customer
  has_many :order_items, dependent: :destroy, autosave: true
  has_many :products, through: :order_items

  accepts_nested_attributes_for :order_items, reject_if: proc { |attr| attr[:quantity].blank? }, allow_destroy: true

  validates_presence_of :first_name, :last_name, :address_1, :zip_code, :city

  before_save :mark_items_for_destruction

  def self.ordered
    order(created_at: :desc)
  end

  def self.paid_by_invoice
    where(payed_cash: false)
  end

  def self.paid_by_cash
    where(payed_cash: true)
  end

  def payed_cash?
    cash_discount.negative?
  end

  def to_s
    "Rechnung #{id}"
  end

  def customer_name
    "#{first_name} #{last_name}"
  end

  def customer_address
    [address_1, address_2, "#{zip_code} #{city}"].reject(&:blank?).join("\n")
  end

  def contact_info
    [first_name, last_name, phone, email].compact.join(', ')
  end

  def assign_customer_attributes(customer)
    assign_attributes(
      customer_id: customer.id,
      first_name: customer.first_name,
      last_name: customer.last_name,
      address_1: customer.address_1,
      address_2: customer.address_2,
      zip_code: customer.zip_code,
      city: customer.city,
      phone: customer.phone,
      email: customer.email
    )
  end

  def mark_items_for_destruction
    order_items.each do |item|
      item.mark_for_destruction if item.quantity.zero?
    end
  end

  def total_item_count
    order_items.count
  end

  def spring_discount?
    !spring_discount.zero?
  end

  def shipping_cost?
    !shipping_cost.zero?
  end

  def cash_discount_percentage
    Account.default.cash_discount_percentage
  end

  def bulk_discount_percentage
    Account.default.bulk_discount_percentage
  end

  def spring_discount_percentage
    Account.default.spring_discount_percentage
  end

  def total_quantity
    order_items.sum(&:quantity)
  end

  def total_item_price
    order_items.sum(&:total_price)
  end

  def cash_discounted_price
    total_item_price + cash_discount
  end

  def bulk_discounted_price
    cash_discounted_price + bulk_discount
  end

  def spring_discounted_price
    bulk_discounted_price + spring_discount
  end

  def price_with_vat
    spring_discounted_price + vat_amount
  end

  def price_with_shipping_cost
    price_with_vat + shipping_cost
  end

  def total_price
    (price_with_shipping_cost * 20.0).round / 20.0
  end

  def total_price_f
    '%.2f' % total_price
  end
end
