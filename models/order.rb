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

  def to_s
    "Bestellung #{id}"
  end

  def customer_name
    customer.name
  end

  def customer_info
    "#{customer.name}, #{customer.address_1}, #{customer.zip_code} #{customer.city}"
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
      item.mark_for_destruction if item.quantity == 0
    end
  end

  def total_item_count
    order_items.count
  end

  def total_quantity
    order_items.sum &:quantity
  end

  def total_item_price
    order_items.sum &:total_price
  end

  def total_price_excl_vat
    total_item_price
  end

  def total_price
    current_total = total_item_price
    current_total += bulk_discount if bulk_discount
    current_total += spring_discount if spring_discount
    current_total += shipping_cost if shipping_cost
    current_total += vat_amount
    (current_total*20.0).ceil/20.0
  end

  def total_price_f
    '%.2f' % total_price
  end
end
