class OrderPdf
  include Prawn::View

  attr_reader :order

  def initialize(order)
    @order = order
  end

  def render
    header

    super
  end

  def header
    spacing = 10
    font_size 20
    text "Bestellformular Verpackungsmaterial"

    move_down spacing * 2

    font_size 14
    text "Bestellt von:"
    move_down spacing

    text "Menge: "
    move_down spacing

    text "Preis Total: "
    move_down spacing
  end
end
