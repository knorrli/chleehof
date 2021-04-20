Chleehof::Admin.controllers :inventory do
  
  get :index do
    @products = Product.order(:track_stock, :name)
    render 'inventory/index'
  end

  post :index do
    InventoryService.set_stock_quantities(params[:inventory])
    flash[:success] = "Der Lagerbestand wurde angepasst!"
    redirect_to url(:inventory, :index)
  end

end
