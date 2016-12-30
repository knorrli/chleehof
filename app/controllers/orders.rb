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

  get :show, with: :id, provides: [:html, :pdf] do
    @order = Order.find params[:id]
    # case content_type
    # when :html then render 'show'
    # when :pdf then send_data(
    #   OrderPdf.new(@order).render,
    #   filename: 'test.pdf',
    #   type: 'application/pdf',
    #   disposition: :inline
    # end
  end

  get :print_form, provides: :pdf do
    OrderPdf.new(Order.new).render
  end
end
