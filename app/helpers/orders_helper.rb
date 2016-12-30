# Helper methods defined here can be accessed in any controller or view in the application

module Chleehof
  class App
    module OrdersHelper

      def current_order
        @order ||= (Order.find_by(id: session[:order_id]) || Order.new)
      end

      def item_for_product(product)
        current_order.order_items.find_or_initialize_by(product_id: product.id)
      end
    end

    helpers OrdersHelper
  end
end
