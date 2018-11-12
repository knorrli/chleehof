class OrderPdf
  include Prawn::View

  attr_reader :order

  def initialize(order)
    @order = order
  end

  def render
    render_order_page
    start_new_page
    render_order_page
    super
  end

  def render_order_page
    header
    customer_address
    move_down 40
    order_header
    move_down 15
    line_items
    move_down 30
    footer
  end

  private

  def header
    font_size 9
    text_box "MwSt-Nr.: CHE-110.836.851", at: [420, cursor]
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
    bounding_box([300, 640], width: 500) do
      text order.customer_name
      text order.customer_address
    end

  end

  def order_header
    draw_text "RECHNUNG vom #{@order.updated_at.strftime('%d.%m.%Y')}", style: :bold, at: [0, cursor]
  end

  def line_items
    table = []

    header = ["Nr.", "Artikel", "Bestellmenge", "Preis", "Total CHF"]
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

    col1 = bounds.width / 12

    table = make_table table, header: true, width: bounds.width, column_widths: [col1, col1*5, col1*2, col1*2, col1*2], cell_style: { padding: [3, 5, 3, 5], borders: [] }
    table.column(2).style align: :right
    table.column(3).style align: :right
    table.column(4).style align: :right

    table.row(0).style font_style: :bold, borders: [:bottom]
    table.row(-5).style font_style: :bold, borders: [:top]
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
