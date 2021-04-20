class Customer < ActiveRecord::Base
  has_many :orders

  validates_presence_of :first_name, :last_name, unless: :company?
  validates_presence_of :address_1, :zip_code, :city

  def self.search(query)
    query = query.downcase
    where('lower(company) LIKE ? OR lower(last_name) LIKE ? OR lower(first_name) LIKE ? OR lower(zip_code) LIKE ? OR lower(city) LIKE ?', "%#{query}%", "%#{query}%", "%#{query}%", "#{query}%", "%#{query}%")
  end

  def self.newest_customers
    order(created_at: :desc).last(100)
  end

  def self.ordered
    order(:last_name, :company, :first_name)
  end

  def name
    company.present? ? company : "#{last_name} #{first_name}"
  end

  def as_json(options)
    super.merge(name: name)
  end
end
