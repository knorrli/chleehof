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
    text "vomhof@luethi-chleehof.ch"
    font_size 14
    text "www.luethi-chleehof.ch"
    move_down 10
    font_size 10
    text "IBAN Nr.: CH58 0631 3640 3035 2090 2", style: :bold

  end

  def customer_address
    font_size 12
    bounding_box([300, 640], width: 500) do
      text order.company if order.company.present?
      text order.customer_name
      text order.customer_address
    end

  end

  def order_header
    draw_text "RECHNUNG #{@order.id} vom #{@order.updated_at.strftime('%d.%m.%Y')}", style: :bold, at: [0, cursor]
  end

  def line_items
    table = []

    header = ["Nr.", "Artikel", "Bestellmenge", "Preis", "Total CHF"]
    table << header

    @order.order_items.each do |item|
      table << [item.identifier, item.name, "#{item.quantity} Stk.", formatted_price(item.price), item.total_price_f]
    end

    table << [{content: "Total Artikel", colspan: 4}, formatted_price(@order.total_item_price, currency: true)]
    if @order.spring_discount?
      table << [{ content: "Frühlingsrabatt: #{@order.spring_discount_percentage}% von #{formatted_price(@order.total_item_price, currency: true)}", colspan: 3}, formatted_price(@order.spring_discount), formatted_price(@order.item_total_incl_discounts)]
    end
    table << [{content: "Barzahlungsrabatt ab CHF #{@order.cash_discount_treshold}: #{@order.cash_discount_percentage}% von #{formatted_price(@order.item_total_incl_discounts, currency: true)}", colspan: 3}, formatted_price(@order.cash_discount), formatted_price(@order.total_price_incl_cash_discount)]
    table << [{ content: "Mengenrabatt ab CHF #{@order.bulk_discount_treshold}: #{@order.bulk_discount_percentage}% von #{formatted_price(@order.item_total_incl_discounts, currency: true)}", colspan: 3}, formatted_price(@order.bulk_discount), formatted_price(@order.total_price_incl_cash_and_bulk_discounts)]
    table << [{ content: "MwSt. #{@order.vat_percentage}% von #{formatted_price(@order.total_price_incl_cash_and_bulk_discounts, currency: true)}", colspan: 3}, formatted_price(@order.vat_amount), formatted_price(@order.total_price_incl_vat)]
    table << [{ content: "Total inkl. #{@order.vat_percentage}% MwSt.", colspan: 4}, formatted_price(@order.total_price_incl_vat, currency: true)]
    if @order.shipping_cost?
      table << [{ content: "Versandkosten", colspan: 3}, formatted_price(@order.shipping_cost), formatted_price(@order.total_price(rounded: false))]
    end
    table << [{ content: "Rundungsdifferenz", colspan: 4}, formatted_price(@order.rounding_difference)]
    table << [{ content: "GESAMTTOTAL", colspan: 4}, formatted_price(@order.total_price, currency: true)]

    col1 = bounds.width / 24

    table = make_table table, header: true, width: bounds.width, column_widths: [col1*2, col1*12, col1*4, col1*2, col1*4], cell_style: { padding: [3, 3, 3, 3], borders: [:left, :right, :top, :bottom] }
    table.column(2).style align: :right
    table.column(3).style align: :right
    table.column(4).style align: :right

    table.row(0).style font_style: :bold, borders: [:top, :bottom, :left, :right]
    total_excl_vat_row = ((@order.spring_discount? && @order.shipping_cost?) ? -9 : (@order.spring_discount? || @order.shipping_cost?) ? -8 : -7)
    total_incl_vat_row = @order.shipping_cost? ? -4 : -3
    table.row(total_excl_vat_row).style font_style: :bold, borders: [:top, :bottom, :left, :right]
    table.row(total_incl_vat_row).style font_style: :bold, borders: [:top, :bottom, :left, :right]
    table.row(-1).style font_style: :bold, borders: [:top, :bottom, :left, :right]

    table.draw

    move_down 10
  end

  def footer
    # rectangle [0, cursor], 10, 10
    # stroke
    text_box payment_text, style: :bold, at: [0, cursor]
    # move_down font_size + 5
    # rectangle [0, cursor], 10, 10
    # stroke
    # text_box "Betrag auf Rechnung, zahlbar innert 30 Tagen", style: :bold, at: [15, cursor]
  end

  def payment_text
    if @order.payed_cash?
      "Betrag dankend erhalten"
    else
      "Betrag auf Rechnung, zahlbar innert 30 Tagen bis am #{(@order.updated_at + 30.days).strftime('%d.%m.%Y')}"
    end
  end

  def formatted_price(price, options = {})
    options[:currency] ? ("CHF %.2f" % price) : ('%.2f' % price)
  end
end
