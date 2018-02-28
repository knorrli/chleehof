module Presenters
  class Accounting

    attr_accessor :year

    def initialize(args = {})
      @year = args.fetch(:year, Date.today.year.to_s)
    end

    def years
      (start_date.year..end_date.year).map(&:to_s)
    end

    def months
      @months ||= (1..12).inject({}) do |hash, month|
        month_name = I18n.t('date.month_names')[month]
        hash[month_name] = Order.where("date_part('year', created_at) = ? AND date_part('month', created_at) = ?", year, month).sum(&:total_price)
        hash
      end
    end

    def total_year
      months.values.sum
    end

    def start_date
      @start_date ||= Order.order(:created_at).first.try(:created_at) || Date.new(2018, 01, 01)
    end

    def end_date
      Date.today
    end

  end
end
