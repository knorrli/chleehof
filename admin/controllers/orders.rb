Chleehof::Admin.controllers :orders do
  get :index do
    @orders = Order.all
    render 'orders/index'
  end

  get :new do
    @order = Order.new
    if customer_id = params[:customer_id]
      @order.assign_customer_attributes Customer.find_by(id: customer_id)
      puts @order.inspect
    end
    render 'orders/new'
  end

  post :create do
    @order = Order.new(params[:order])
    if @order.save
      flash[:success] = pat(:create_success, :model => 'Order')
      params[:save_and_continue] ? redirect(url(:orders, :index)) : redirect(url(:orders, :edit, :id => @order.id))
    else
      flash.now[:error] = pat(:create_error, :model => 'order')
      render 'orders/new'
    end
  end

  get :edit, :with => :id do
    @order = Order.find(params[:id])
    if @order
      render 'orders/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'order', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @order = Order.find(params[:id])
    if @order
      if @order.update_attributes(params[:order])
        flash[:success] = pat(:update_success, :model => 'Order', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:orders, :index)) :
          redirect(url(:orders, :edit, :id => @order.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'order')
        render 'orders/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'order', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    order = Order.find(params[:id])
    if order
      if order.destroy
        flash[:success] = pat(:delete_success, :model => 'Order', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'order')
      end
      redirect url(:orders, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'order', :id => "#{params[:id]}")
      halt 404
    end
  end
end
