class OrderPdf
  include Prawn::View

  def render
    header
    products

    number_pages "<page>/<total>", align: :center, style: :bold, at: [bounds.left, 0]

    super
  end

  def header
    font_size 15
    text "Bestellung Verpackungsmaterial", align: :center
    font_size 10
    text "Familie Lüthi, Chleehof 8, 3422 Kirchberg", align: :center
    text "034 445 53 89, fam_luethi@hotmail.com", align: :center
  end

  def products
    Product.products.each do |product|

      table = []
      header = ["Anz.", "Artikelbezeichnung", "CHF/Stk.", "Total"]
      table << header
      product.variants.each do |variant, price|
        table << ["", variant.to_s, "#{'%.02f' % price}", ""]
      end
      table = make_table table, column_widths: { 0 => 60, 1 => (bounds.width - 180), 2 => 60, 3 => 60 }, cell_style: { padding: [1, 5, 2, 5] }
      table.row(0).style font_style: :bold
      table.column(2).style align: :right

      if cursor < (table.height + 10)
        start_new_page
      end
      font_size 12
      text product.name, style: :bold
      font_size 10
      table.draw

      move_down 10
    end
  end
end
