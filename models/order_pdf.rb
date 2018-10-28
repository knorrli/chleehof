class OrderPdf
  include Prawn::View

  attr_reader :order, :customer

  def initialize(order)
    @order = order
    @customer = order.customer
  end

  def render
    header
    move_down 50
    customer_address
    move_down 60
    line_items

    number_pages "<page>/<total>", align: :center, style: :bold, at: [bounds.left, 0]
    super
  end

  private

  def header
    font_size 15
    text "Rechnung Verpackungsmaterial", align: :center
    font_size 10
    text "Familie Lüthi, Chleehof 8, 3422 Kirchberg", align: :center
    text "034 445 53 89, fam_luethi@hotmail.com", align: :center
  end

  def customer_address
    font_size 12
    bounding_box([0, cursor], width: 500) do
      text customer.name
      text customer.address
      if phone = customer.phone
        text phone
      end
      if email = customer.email
        text email
      end
    end

  end

  def line_items
    table = []

    header = ["ArtikelNr.", "Artikelbezeichnung", "Bestellmenge", "Preis", "Total CHF"]
    table << header

    @order.order_items.each do |item|
      table << [item.identifier, item.name, item.quantity, formatted_price(item.price), item.total_price_f]
    end

    table << ["TOTAL exkl MwSt.", "", "#{@order.total_quantity}", "", "CHF #{formatted_price(@order.total_item_price)}"]
    table << ["Barzahlungsrabatt #{@order.cash_discount_percentage}%", "", "", "formatted_price #{@order.cash_discount}"]
    table << ["Mengenrabatt ab CHF #{current_account.bulk_discount_treshold}: #{current_account.bulk_discount_percentage}%", "", "", ""]

    table = make_table table, width: bounds.width, cell_style: { borders: [] }
    table.row(0).style font_style: :bold, borders: [:bottom]
    table.column(2).style align: :right
    table.column(3).style align: :right
    table.column(4).style align: :right

    table.draw

    move_down 10
  end

  def formatted_price(price, options = {})
    options[:currency] ? ("CHF %.2f" % price) : ('%.2f' % price)
  end
end
