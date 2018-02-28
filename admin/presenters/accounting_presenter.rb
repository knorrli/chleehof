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
        hash[month_name] = Order.where("strftime('%Y', created_at) = ? AND cast(strftime('%m', created_at) as int) = ?", year, month).sum(&:total_price)
        hash
      end
    end

    def total_year
      months.values.sum
    end

    def start_date
      @start_date ||= Order.order(:created_at).first.created_at
    end

    def end_date
      Date.today
    end

  end
end
