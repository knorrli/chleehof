class ProductListPdf
  include Prawn::View

  attr_accessor :products

  def initialize(products: Product.ordered)
    @products = products
  end

  def render
    render_product_list
    super
  end

  def render_product_list
    header
    font_size 8
    product_list
  end

  private

  def header
    logo_path = "#{Chleehof::App.public_dir}/images/vomhof_logo.png"

    font_size 22
    text "Bestellformular #{Date.current.year}", style: :bold, align: :center

    image logo_path, at: [bounds.left, cursor], width: 50
    image logo_path, at: [bounds.right - 50, cursor], width: 50

    move_down 10

    font_size 11

    bounding_box [60, cursor], width: bounds.width - 100 do
      text "\u2022 Abholrabatt von #{Configuration.cash_discount_percentage} % auf alle Artikel dieser Bestellliste"
      text "\u2022 Rabatt von #{Configuration.bulk_discount_percentage} % auf den Gesamtpreis bei einem Kauf ab CHF #{formatted_price(Configuration.bulk_discount_treshold)} (ohne MwSt.)"
      text "\u2022 Frühlingsrabatt von #{Configuration.spring_discount_percentage} % auf allen Bestellungen und Auslieferungen im März und April"
      text "\u2022 Kleinmengenzuschlag bei unter CHF 30.00 Warenwert (exkl. MwSt.)"
    end
    move_down 20
  end

  def product_list
    products_table = []
    products_table << ["Anzahl", "Einheit", make_cell(content: "Art. Nr.", align: :right), "Artikelbezeichnung", "Gebinde / Details", make_cell(content: "Preis/Gebinde in CHF", align: :right)]

    products.each do |product|
      products_table << ["", "", make_cell(content: product.identifier, align: :right), product.name, "", make_cell(content: formatted_price(product.price), align: :right)]
    end

    products_table = make_table(products_table, header: true, width: bounds.width) do
      rows(0).font_style = :bold
    end

    products_table.draw
  end

  def formatted_price(price, options = {})
    options[:currency] ? ("CHF %.2f" % price) : ('%.2f' % price)
  end
end
