class MonthlyOrderOverviewPdf
  include Prawn::View

  attr_reader :year, :month, :orders

  def initialize(year, month)
    @year = year
    @month = month
    @orders = Order.where("date_part('year', created_at) = ? AND date_part('month', created_at) = ?", year, month).order(payed_cash: :asc, :created_at: :asc)
  end

  def render
    render_header

    bounding_box([0, cursor], width: bounds.width) do
      render_orders_table
    end

    number_pages "<page>/<total>", align: :center, style: :bold, at: [bounds.left, 0]
    super
  end

  def render_header
    default_font_size = font_size
    month_name = I18n.t('date.month_names')[month.to_i]
    repeat(:all) do
      text "Rechnungsübersicht #{month_name} #{year}", size: 20, style: :bold, align: :center
    end
    font_size default_font_size
  end

  def render_orders_table
    orders_table = []
    orders_table << [
      I18n.t('models.order.attributes.created_at'),
      I18n.t('models.order.attributes.customer'),
      I18n.t('models.order.attributes.zip_code'),
      I18n.t('models.order.attributes.city'),
      I18n.t(:payment_method),
      I18n.t('models.order.attributes.total_price')
    ]
    orders.each do |order|
      orders_table << [
        order.created_at.strftime('%d.%m.%Y'),
        order.customer_name,
        order.zip_code,
        order.city,
        order.payed_cash? ? I18n.t('payment_methods.cash') : I18n.t('payment_methods.invoice'),
        order.total_price_f
      ]
    end
    orders_table << ['', 'Total', '', '', '', orders.sum(&:total_price)]
    orders_table = make_table(orders_table, header: true, width: bounds.width, cell_style: { })
    orders_table.column(-1).style align: :right
    orders_table.row(0).style font_style: :bold
    orders_table.row(-1).style font_style: :bold
    orders_table.draw
  end
end
