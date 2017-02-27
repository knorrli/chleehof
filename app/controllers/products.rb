Chleehof::App.controllers :products do
  get :index, map: '/verpackungsmaterial' do
    @products = Product.products
    render :index
  end

  get :show, with: :id do
    @product = Product.find params[:id]
    render :show
  end
end
