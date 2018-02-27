# Helper methods defined here can be accessed in any controller or view in the application

module Chleehof
  class App
    module ProductsHelper
      def image(product, options = {})
        image_tag img_path(product), options.merge(class: 'img-responsive center-block')
      end

      def img_path(product)
        "/images/products/#{Product.categories[product.category][:path]}/#{product.photo}"
      end
    end

    helpers ProductsHelper
  end
end
