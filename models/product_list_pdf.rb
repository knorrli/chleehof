class ProductListPdf
  include Prawn::View

  attr_reader :products

  def initialize(products)
    @products = products
  end

  def render
    render_product_table

    number_pages "<page>/<total>", align: :center, style: :bold, at: [bounds.left, 0]
    super
  end

  def render_product_table
    product_table = []
    product_table << ["Nummer", "Artikel", "Preis CHF"]
    products.each do |product|
      product_table << [product.identifier, product.name, product.price_f]
    end
    product_table = make_table(product_table, header: true, width: bounds.width, cell_style: { })
    product_table.column(-1).style align: :right
    product_table.row(0).style font_style: :bold
    product_table.draw
  end
end
