class Product < ActiveRecord::Base
  has_many :photos

  def self.ordered
    order(:created_at)
  end
end
