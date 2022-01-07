Chleehof::Admin.controllers :product_prices do
  get :index do
    @products = Product.order(name: :asc)
    render 'product_prices/index'
  end

  post :index do
    if ProductPricesService.set_product_prices(params[:product_prices])
      flash[:success] = "Die Preise wurden angepasst!"
      redirect_to url(:product_prices, :index)
    else
      flash[:error] = "Die Preise konnten nicht angepasst werden!"
      render "product_prices/index"
    end
  end
end
