Chleehof::App.controllers :orders do

  get :new do
    @order = Order.new
    @products = Product.ordered
    render 'new'
  end

  post :create do
    @order = Order.new params[:order]
    if @order.save
      redirect_to url(:orders, :show, id: @order.id)
    else
      puts @order.errors.inspect
      @products = Product.ordered
      render 'new'
    end
  end

  get :show, with: :id do
    @order = Order.find params[:id]
    render 'show'
  end
end
