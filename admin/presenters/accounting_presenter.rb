module Presenters
  class Accounting

    attr_accessor :year

    def initialize(args = {})
      @year = args.fetch(:year, Date.current.year.to_s)
    end

    def years
      (start_date.year..end_date.year).map(&:to_s)
    end

    def months
      @months ||= (1..12).to_a.inject({}) do |hash, month|
        month_name = I18n.t('date.month_names')[month]
        cash_total = Order.paid_by_cash.where("date_part('year', created_at) = ? AND date_part('month', created_at) = ?", year, month).sum(&:total_price)
        invoice_total = Order.paid_by_invoice.where("date_part('year', created_at) = ? AND date_part('month', created_at) = ?", year, month).sum(&:total_price)
        overall_total = cash_total + invoice_total
        hash[month] = {
          month_name: month_name,
          cash: cash_total,
          invoice: invoice_total,
          total: overall_total
        }
        hash
      end
    end

    def total_year_cash
      @total_year_cash ||= months.values.sum { |month| month[:cash] }
    end

    def total_year_invoice
      @total_year_invoice ||= months.values.sum { |month| month[:invoice] }
    end

    def total_year
      total_year_cash + total_year_invoice
    end

    def start_date
      @start_date ||= Order.order(:created_at).first.try(:created_at) || Date.new(2018, 01, 01)
    end

    def end_date
      Date.current
    end

  end
end
