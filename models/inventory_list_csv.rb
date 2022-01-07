require 'csv'

class InventoryListCsv
  attr_reader :products

  def initialize(products)
    @products = products
  end

  def generate
    CSV.generate("\uFEFF", headers: true, col_sep: ";") do |csv|
      csv << headers
      products.each_with_index do |product, index|
        csv << product_row(product, index+2)
      end
      csv << [
        '',
        '',
        '',
        '',
        "=SUBTOTAL(9,E2:E#{products.count+1})"
      ]
    end
  end

  def headers
    [
      "Bestand",
      "Nummer",
      "Artikel",
      "Preis CHF",
      "Total CHF"
    ]
  end

  def product_row(product, index)
    [
      product.stock_quantity,
      product.identifier,
      product.name,
      product.price,
      "=A#{index}*D#{index}",
    ]
  end

  def render_header
    default_font_size = font_size
    repeat(:all) do
      text "Inventar vom #{Date.today.strftime('%d.%m.%Y')}", size: 20, style: :bold, align: :center
    end
    font_size default_font_size
  end

  def render_product_table
    product_table = []
    product_table << ["", "Bestand", "Nummer", "Artikel", "Preis CHF"]
    products.each do |product|
      product_table << ["", product.stock_quantity, product.identifier, product.name, product.price_f]
    end
    product_table = make_table(product_table, header: true, width: bounds.width, cell_style: { })
    product_table.column(-1).style align: :right
    product_table.row(0).style font_style: :bold
    product_table.draw
  end
end
