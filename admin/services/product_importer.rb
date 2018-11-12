require 'csv'
class ProductImporter
  def self.run(filename)
    new.run(filename)
  end

  def run(filename)
    CSV.foreach(filename, headers: true, col_sep: ',').each_with_index do |row, index|
      next if row[1].blank?

      product = Product.find_by(
        identifier: row[0],
        name: row[1],
      )
      product ||= Product.create(
        identifier: row[0],
        name: row[1],
      )
      product.update_attributes(price: (row[3].present? ? row[3] : row[2]))

      if product.valid?
        product.save
      else
        puts "INVALID: #{product.inspect}"
      end
    end
  end
end
