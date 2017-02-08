class Order < ActiveRecord::Base
  has_many :order_items
  has_many :products, through: :order_items

  accepts_nested_attributes_for :order_items, reject_if: proc { |attr| attr[:quantity].blank? }

  validates_presence_of :name
  validate :has_email_or_phone

  def to_s
    "Bestellung #{id}"
  end

  def contact_info
    [name, phone, email].compact.join(', ')
  end

  def total_item_count
    order_items.count
  end

  def total_item_quantity
    order_items.sum &:quantity
  end

  def total_item_price
    order_items.sum &:price
  end

  def currency
    "CHF"
  end

  private

  def has_email_or_phone
    self.email = nil if email.blank?
    self.phone = nil if phone.blank?
    return true if email || phone
    errors[:email_or_phone] = "Email oder Telefon muss angegeben werden"
    return false
  end
end
