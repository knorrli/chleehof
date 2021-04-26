Chleehof::Admin.controllers :inventory do
  
  get :index, provides: [:pdf, :html] do
    @products = Product.order(:track_stock, :name)
    case content_type
    when :pdf
      InventoryListPdf.new(@products).render
    when :html
      render 'inventory/index'
    end
  end

  post :index do
    InventoryService.set_stock_quantities(params[:inventory])
    flash[:success] = "Der Lagerbestand wurde angepasst!"
    redirect_to url(:inventory, :index)
  end

end
