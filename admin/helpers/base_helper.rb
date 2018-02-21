# Helper methods defined here can be accessed in any controller or view in the application

module Chleehof
  class Admin
    module BaseHelper
      def formatted_price(price, options = {})
        options[:currency] ? ("CHF %.2f" % price) : ('%.2f' % price)
      end
    end

    helpers BaseHelper
  end
end
