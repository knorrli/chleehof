class OrderPdf
  include Prawn::View

  attr_reader :order

  def initialize(order)
    @order = order
  end

  def render
    header
    order_items

    super
  end

  def header
    font_size 20
    text_box "Bestellung Verpackungsmaterial", at: [bounds.left, cursor]

    font_size 14
    text_box order.created_at.strftime('%d.%m.%Y %H:%M'), at: [bounds.right - 110, cursor]

    spacing = 20
    move_down spacing * 2

    font_size 12
    text_box "Name:", width: 150, at: [bounds.left, cursor]
    text_box order.name, style: :bold, at: [bounds.left + 100, cursor]
    move_down spacing

    text_box "Email:", width: 150, at: [bounds.left, cursor]
    text_box order.email, style: :bold, at: [bounds.left + 100, cursor]
    move_down spacing

    text_box "Telefon:", width: 150, at: [bounds.left, cursor]
    text_box order.phone, style: :bold, at: [bounds.left + 100, cursor]
    move_down spacing

    text_box "Total Menge:", width: 150, at: [bounds.left, cursor]
    text_box "#{order.total_item_quantity} Stück", style: :bold, at: [bounds.left + 100, cursor]
    move_down spacing

    text_box "Total Preis:", width: 150, at: [bounds.left, cursor]
    text_box "#{order.total_item_price} #{order.currency}", style: :bold, at: [bounds.left + 100, cursor]
    move_down spacing * 2
  end

  def order_items
    item_array = order.order_items.map do |item|
      item_table_body_procs.map do |p|
        p.call(item)
      end
    end
    item_array.prepend(item_header)
    item_array.append(order_total_row)
    item_table = make_table item_array, width: bounds.width, cell_style: { borders: [:bottom], border_width: 0 }
    item_table.rows(0).style(border_width: 1, font_style: :bold)
    item_table.columns(2).style(align: :right)
    item_table.columns(3).style(align: :right)
    item_table.columns(-2).style(align: :right)
    item_table.columns(-1).style(align: :right)
    item_table.rows(-1).style(borders: [:top, :bottom], border_width: 1, font_style: :bold)
    item_table.rows(-1).columns(0).style(borders: [:top], border_width: 1)
    item_table.draw
  end

  def item_header
    item_table_attributes.keys
  end

  def item_table_body_procs
    item_table_attributes.values
  end

  def item_table_attributes
    @item_table_attributes ||= {
      "" => ->(item) { { image: item.product.photo.path(:medium), fit: [80, 80] } },
      "Artikel" => ->(item) { item.to_s },
      "Anzahl" => ->(item) { "#{item.quantity} Stk." },
      " " => ->(item) { "x" },
      "Preis" => ->(item) { "#{item.price} CHF" },
      "Total" => ->(item) { "#{item.total_price} CHF" }
    }
  end

  def order_total_row
    [
      "",
      "TOTAL",
      "#{order.total_item_quantity} Stk.",
      "",
      "",
      "#{order.total_item_price} CHF"
    ]
  end
end
