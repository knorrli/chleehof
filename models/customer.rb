class Customer < ActiveRecord::Base
  has_many :orders

  validates_presence_of :first_name, :last_name, :address_1, :zip_code, :city

  def self.search(input)
    Customer.
      where('last_name LIKE ? OR first_name LIKE ? OR zip_code LIKE ?', "%#{input}%", "%#{input}%", "%#{input}%").
      limit(10)
  end

  def self.ordered
    order(:last_name, :first_name)
  end

  def name
    "#{last_name} #{first_name}"
  end
end
