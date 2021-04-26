class InventoryListPdf
  include Prawn::View

  attr_reader :products

  def initialize(products)
    @products = products
  end

  def render
    render_header

    bounding_box([0, cursor], width: bounds.width) do
      render_product_table
    end

    number_pages "<page>/<total>", align: :center, style: :bold, at: [bounds.left, 0]
    super
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
      product_table << ["", "", product.identifier, product.name, product.price_f]
    end
    product_table = make_table(product_table, header: true, width: bounds.width, cell_style: { })
    product_table.column(-1).style align: :right
    product_table.row(0).style font_style: :bold
    product_table.draw
  end
end
