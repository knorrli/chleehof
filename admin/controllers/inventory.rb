Chleehof::Admin.controllers :inventory do
  
  get :index, provides: [:pdf, :html] do
    case content_type
    when :pdf
      @products = Product.order(name: :asc)
      InventoryListPdf.new(@products).render
    when :html
      @products = Product.order(track_stock: :asc, name: :asc)
      render 'inventory/index'
    end
  end

  post :index do
    InventoryService.set_stock_quantities(params[:inventory])
    flash[:success] = "Der Lagerbestand wurde angepasst!"
    redirect_to url(:inventory, :index)
  end

end
