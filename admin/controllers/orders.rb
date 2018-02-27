Chleehof::Admin.controllers :orders do
  get :index do
    @orders = Order.ordered
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
      flash[:success] = "Bestellung für #{@order.name} wurde gespeichert"
      redirect(url(:orders, :index))
    else
      flash.now[:error] = "Bestellung konnte nicht gespeichert werden"
      render 'orders/new'
    end
  end

  get :edit, :with => :id do
    @order = Order.find(params[:id])
    if @order
      render 'orders/edit'
    else
      flash[:warning] = "Bestellung konnte nicht gefunden werden"
      halt 404
    end
  end

  put :update, :with => :id do
    @order = Order.find(params[:id])
    if @order
      if @order.update_attributes(params[:order])
        flash[:success] = "Bestellung für #{@order.name} wurde angepasst"
        redirect(url(:orders, :edit, id: @order.id))
      else
        flash.now[:error] = "Bestellung konnte nicht angepasst werden"
        render 'orders/edit'
      end
    else
      flash[:warning] = "Bestellung konnte nicht gefunden werden"
      halt 404
    end
  end

  delete :destroy, :with => :id do
    order = Order.find(params[:id])
    if order
      if order.destroy
        flash[:success] = "Bestellung wurde gelöscht"
      else
        flash[:error] = "Bestellung konnte nicht gelöscht werden"
      end
      redirect url(:orders, :index)
    else
      flash[:warning] = "Bestellung konnte nicht gefunden werden"
      halt 404
    end
  end
end
