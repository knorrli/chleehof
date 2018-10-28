class Customer < ActiveRecord::Base
  has_many :orders

  validates_presence_of :first_name, :last_name, unless: :company?
  validates_presence_of :address_1, :zip_code, :city

  def self.search(query)
    query = query.downcase
    where('lower(company) LIKE ? OR lower(last_name) LIKE ? OR lower(first_name) LIKE ? OR lower(zip_code) LIKE ? OR lower(city) LIKE ?', "%#{query}%", "%#{query}%", "%#{query}%", "#{query}%", "%#{query}%")
  end

  def self.new_customers
    where('created_at > ?', 1.week.ago).order(created_at: :desc)
  end

  def self.ordered
    order(:last_name, :company, :first_name)
  end

  def name
    company.present? ? company : "#{last_name} #{first_name}"
  end

  def address
    [address_1, address_2, "#{zip_code} #{city}"].reject(&:blank?).join("\n")
  end

  def as_json(options)
    super.merge(name: name)
  end
end
