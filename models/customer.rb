class Customer < ActiveRecord::Base
  has_many :orders

  validates_presence_of :first_name, :last_name, unless: :company?
  validates_presence_of :address_1, :zip_code, :city

  def self.search(query)
    where('company LIKE ? OR last_name LIKE ? OR first_name LIKE ? OR zip_code LIKE ? OR city LIKE ?', "%#{query}%", "%#{query}%", "%#{query}%", "%#{query}%", "%#{query}%")
  end

  def self.ordered
    order(:company, :last_name, :first_name)
  end

  def name
    company.present? ? company : "#{last_name} #{first_name}"
  end

  def as_json(options)
    super.merge(name: name)
  end
end
