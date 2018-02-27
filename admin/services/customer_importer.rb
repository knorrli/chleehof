require 'csv'
class CustomerImporter
  def self.run(filename)
    new.run(filename)
  end

  def run(filename)
    CSV.foreach(filename, headers: true, col_sep: ',').each_with_index do |row, index|
      customer = Customer.new(
        last_name: row[0],
        first_name: row[1],
        address_1: row[4],
        zip_code: row[5],
        city: row[6],
        phone: row[7].present? ? row[7] : row[8]
      )

      if customer.first_name.blank?
        customer.company = row[0]
        customer.last_name = nil
      end

      if customer.valid?
        customer.save
      else
        puts "INVALID: #{customer.inspect}"
      end
    end
  end
end
