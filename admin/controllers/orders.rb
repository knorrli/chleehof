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
    logger.info params.inspect
    require 'pry'; binding.pry
    @order = Order.new(params[:order])
    @order.bulk_discount_treshold = current_account.bulk_discount_treshold
    if @order.save
      flash[:success] = "Rechnung für #{@order.customer_name} wurde gespeichert"
      redirect(url(:orders, :show, id: @order.id))
    else
      flash.now[:error] = "Rechnung konnte nicht gespeichert werden"
      render 'orders/new'
    end
  end

  get :show, with: :id, provides: [:html, :pdf] do
    @order = Order.find(params[:id])
    case content_type
    when :html
      render  'orders/show'
    when :pdf
      OrderPdf.new(@order).render
    end
  end

  get :edit, :with => :id do
    @order = Order.find(params[:id])
    if @order
      render 'orders/edit'
    else
      flash[:warning] = "Rechnung konnte nicht gefunden werden"
      halt 404
    end
  end

  put :update, :with => :id do
    @order = Order.find(params[:id])
    if @order
      @order.bulk_discount_treshold = current_account.bulk_discount_treshold
      if @order.update_attributes(params[:order])
        flash[:success] = "Rechnung für #{@order.customer_name} wurde angepasst"
        redirect(url(:orders, :show, id: @order.id))
      else
        flash.now[:error] = "Rechnung konnte nicht angepasst werden"
        render 'orders/edit'
      end
    else
      flash[:warning] = "Rechnung konnte nicht gefunden werden"
      halt 404
    end
  end

  delete :destroy, :with => :id do
    order = Order.find(params[:id])
    if order
      if order.destroy
        flash[:success] = "Rechnung wurde gelöscht"
      else
        flash[:error] = "Rechnung konnte nicht gelöscht werden"
      end
      redirect url(:orders, :index)
    else
      flash[:warning] = "Rechnung konnte nicht gefunden werden"
      halt 404
    end
  end
end
