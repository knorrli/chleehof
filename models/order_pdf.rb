class OrderPdf
  include Prawn::View

  def initialize(order)
    @order = order
  end

  def render
    header
    line_items

    number_pages "<page>/<total>", align: :center, style: :bold, at: [bounds.left, 0]

    super
  end

  def header
    font_size 15
    text "Rechnung Verpackungsmaterial", align: :center
    font_size 10
    text "Familie Lüthi, Chleehof 8, 3422 Kirchberg", align: :center
    text "034 445 53 89, fam_luethi@hotmail.com", align: :center
  end

  def line_items
    table = []

    header = ["Artikelbezeichnung", "Anzahl", "Preis", "Total CHF"]
    table << header

    @order.order_items.each do |item|
      table << [item.name, item.quantity, item.price, item.total_price_f]
    end

    table = make_table table, width: bounds.width
    table.row(0).style font_style: :bold
    table.column(1).style align: :right
    table.column(2).style align: :right
    table.column(3).style align: :right

    table.draw

    move_down 10
  end
end
