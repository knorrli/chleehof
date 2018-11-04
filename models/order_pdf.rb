class OrderPdf
  include Prawn::View

  attr_reader :order

  def initialize(order)
    @order = order
  end

  def render
    2.times do
      render_order_page
    end

    number_pages "<page>/<total>", align: :center, style: :bold, at: [bounds.left, 0]
    super
  end

  def render_order_page
    header
    move_down 50
    customer_address
    move_down 60
    order_header
    move_down 40
    line_items
    move_down 30
    footer
  end

  private

  def header
    font_size 9
    draw_text "MwSt-Nr.: CHE-110.836.851", at: [350, cursor - 30]
    font_size 15
    text "Verpackungsmaterial für Direktvermarkter", style: :bold
    font_size 10
    move_down 10
    text "Familie A+B. Lüthi"
    text "Chleehof 8"
    text "3422 Kirchberg"
    text "Tel. 034 445 53 89"
    text "Natel 079 583 77 55"
    text "fam_luethi@hotmail.com"
    font_size 14
    text "www.luethi-chleehof.ch"
    move_down 10
    font_size 10
    text "IBAN Nr.: CH58 0631 3640 3035 2090 2", style: :bold

  end

  def customer_address
    font_size 12
    bounding_box([300, cursor], width: 500) do
      text order.customer_name
      text order.customer_address
    end

  end

  def order_header
    draw_text "RECHNUNG", style: :bold, at: [0, cursor]
    draw_text "Kirchberg, #{@order.updated_at.strftime('%d.%m.%Y')}", at: [bounds.right - 120, cursor]
  end

  def line_items
    table = []

    header = ["ArtikelNr.", "Artikel", "Bestellmenge", "Preis", "Total CHF"]
    table << header

    @order.order_items.each do |item|
      table << [item.identifier, item.name, "#{item.quantity} Stk.", formatted_price(item.price), item.total_price_f]
    end

    table << [{content: "Total exkl. #{@order.vat_percentage}% MwSt.", colspan: 2}, "#{@order.total_quantity} Stk.", "", "CHF #{formatted_price(@order.total_item_price)}"]
    table << [{content: "Barzahlungsrabatt #{@order.cash_discount_percentage}%", colspan: 2}, "", "", "#{formatted_price(@order.cash_discount)}"]
    table << [{ content: "Mengenrabatt ab CHF #{@order.bulk_discount_treshold}: #{@order.bulk_discount_percentage}%", colspan: 2}, "", "", "#{formatted_price(@order.bulk_discount)}"]
    if @order.spring_discount?
      table << [{ content: "Frühlingsrabatt #{@order.spring_discount_percentage}: #{@order.spring_discount}", colspan: 2}, "", "#{formatted_price(@order.spring_discount)}"]
    end
    table << [{ content: "MwSt. #{@order.vat_percentage}%", colspan: 2}, "", "", "#{formatted_price(@order.vat_amount)}"]
    if @order.shipping_cost?
      table << [{ content: "Versandkosten", colspan: 2}, "", "", "#{formatted_price(@order.shipping_cost)}"]
    end
    table << [{ content: "Total inkl. #{@order.vat_percentage}% MwSt.", colspan: 2}, "#{@order.total_quantity} Stk.", "", "#{@order.total_price_f}"]

    table = make_table table, width: bounds.width, cell_style: { borders: [] }
    table.column(2).style align: :right
    table.column(3).style align: :right
    table.column(4).style align: :right

    table.row(0).style font_style: :bold, borders: [:bottom]
    table.row(-6).style font_style: :bold, borders: [:bottom]
    table.row(-1).style font_style: :bold, borders: [:top]

    table.draw

    move_down 10
  end

  def footer
    text "Betrag dankend erhalten", style: :bold
  end

  def formatted_price(price, options = {})
    options[:currency] ? ("CHF %.2f" % price) : ('%.2f' % price)
  end
end
