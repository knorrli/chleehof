require 'csv'

class CustomerExporter
  def self.run(filename)
    new.run(filename)
  end

  def run(filename)
    CSV.open(filename, 'wb') do |csv|
      csv << header
      Customer.find_each do |customer|
        csv << [
          customer.company,
          customer.last_name,
          customer.first_name,
          customer.address_1,
          customer.address_2,
          customer.zip_code,
          customer.city,
          customer.phone,
          customer.email,
          customer.created_at.strftime("%d.%m.%Y")
        ]
      end
    end
  end

  def header
    [
      "Firma",
      "Nachname",
      "Vorname",
      "Strasse",
      "Zutsatz",
      "PLZ",
      "Ort",
      "Telefon",
      "Email",
      "Erstellt Am"
    ]
  end
end

