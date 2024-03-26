class Order < ActiveRecord::Base
  belongs_to :customer
  has_many :order_items, dependent: :destroy, autosave: true
  has_many :products, through: :order_items

  accepts_nested_attributes_for :order_items, reject_if: proc { |attr| attr[:quantity].blank? }, allow_destroy: true

  validates_presence_of :first_name, :last_name, :address_1, :zip_code, :city, :shipping_cost

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
    cash_discount < 0
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

  def set_default_shipping_cost
    self.shipping_cost = 0.0 if shipping_cost.blank?
  end

  def mark_items_for_destruction
    order_items.each do |item|
      item.mark_for_destruction if item.quantity == 0
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

  def item_total_incl_discounts
    total_item_price + spring_discount
  end

  def total_price_incl_cash_discount
    item_total_incl_discounts + cash_discount
  end

  def total_price_incl_cash_and_bulk_discounts
    item_total_incl_discounts + bulk_discount + cash_discount
  end

  def total_price_incl_vat
    total_price_incl_cash_and_bulk_discounts + vat_amount
  end

  def price_incl_shipping_cost
    total_price_incl_vat + shipping_cost
  end

  def total_price(rounded: true)
    if rounded
      (price_incl_shipping_cost * 20.0).round / 20.0
    else
      price_incl_shipping_cost
    end
  end

  def rounding_difference
    total_price - total_price(rounded: false)
  end

  def total_price_f
    '%.2f' % total_price(rounded: true)
  end
end
