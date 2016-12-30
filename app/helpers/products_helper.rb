# Helper methods defined here can be accessed in any controller or view in the application

module Chleehof
  class App
    module ProductsHelper
      def image(product)
        image_tag product.photo.picture.url(:medium), class: 'img-responsive center-block'
      end
    end

    helpers ProductsHelper
  end
end
