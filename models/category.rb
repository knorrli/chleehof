class Category < ActiveRecord::Base

  validates_uniqueness_of :name

  def self.ordered
    order(name: :asc)
  end

  def to_s
    name
  end
end
