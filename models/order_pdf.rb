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
    text @order.to_s, align: :center

    spacing = 20
    move_down spacing * 2

    font_size 14
    text_box "Bestellt von:", width: 150, at: [bounds.left, cursor]
    text_box order.name, style: :bold, at: [bounds.left + 100, cursor]
    move_down spacing

    text_box "Total Menge:", width: 150, at: [bounds.left, cursor]
    text_box "#{order.total_item_quantity} Stück", style: :bold, at: [bounds.left + 100, cursor]
    move_down spacing

    text_box "Total Preis:", width: 150, at: [bounds.left, cursor]
    text_box "#{order.total_item_price} #{order.currency}", style: :bold, at: [bounds.left + 100, cursor]
    move_down spacing
  end

  def order_items
    item_array = order.order_items.map do |item|
      item_table_body_procs.map do |p|
        p.call(item)
      end
    end
    item_array.prepend(item_header)
    table item_array, width: bounds.width, cell_style: { border_width: 0 }
  end

  def item_header
    item_table_attributes.keys
  end

  def item_table_body_procs
    item_table_attributes.values
  end

  def item_table_attributes
    @item_table_attributes ||= {
      "" => ->(item) { { image: item.product.photo.path(:small) } },
      "Artikel" => ->(item) { item.to_s },
      "Menge" => ->(item) { item.quantity.to_s },
      "Preis" => ->(item) { item.price.to_s },
      "Total" => ->(item) { item.total_price.to_s }
    }
  end
end
