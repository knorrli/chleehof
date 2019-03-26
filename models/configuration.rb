class Configuration

  OPTIONS = [
    :cash_discount_percentage,
    :bulk_discount_percentage,
    :bulk_discount_treshold,
    :spring_discount_percentage,
  ].freeze


  def self.account
    @account = Account.find_by!(email: 'admin@luethi-chleehof.ch')
  end

  def self.config_options
    OPTIONS
  end

  def self.method_missing(method_name, *args, &block)
    raise "Config option not implemented!" unless config_options.include?(method_name)

    account.send method_name, *args, &block
  end
end
