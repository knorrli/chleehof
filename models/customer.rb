class Customer < ActiveRecord::Base
  has_many :orders

  validates_presence_of :first_name, :last_name, unless: :company?
  validates_presence_of :address_1, :zip_code, :city

  def self.search(search)
    search = search.downcase
    searches = search.split(' ').map { |word| "#{word}%" }
    query = 'lower(company) LIKE ANY(ARRAY[:searches]) OR lower(last_name) LIKE ANY(ARRAY[:searches]) OR lower(first_name) LIKE ANY(ARRAY[:searches])'
    found_by_name = where(query, { searches: searches } )
    if found_by_name.any?
      found_by_name
    else
      query += 'OR lower(address_1) LIKE ANY(ARRAY[:searches]) OR lower(zip_code) LIKE ANY(ARRAY[:searches]) OR lower(city) LIKE ANY(ARRAY[:searches])'
      where(query, { searches: searches })
    end
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
