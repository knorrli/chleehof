require 'csv'
class ProductImporter
  def self.run(filename)
    new.run(filename)
  end

  def run(filename)
    CSV.foreach(filename, headers: true, col_sep: ',').each_with_index do |row, index|
      next if row[1].blank?

      product = Product.new(
        identifier: row[0],
        name: row[1],
        price: row[2],
      )

      if product.valid?
        product.save
      else
        puts "INVALID: #{product.inspect}"
      end
    end
  end
end
