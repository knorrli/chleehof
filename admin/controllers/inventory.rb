Chleehof::Admin.controllers :inventory do
  
  get :index, provides: [:pdf, :csv, :html] do
    case content_type
    when :pdf
      @products = Product.order(name: :asc)
      InventoryListPdf.new(@products).render
    when :csv
      @products = Product.order(name: :asc)
      content_type 'application/octet-stream'
      attachment "inventar.csv"
      response.write InventoryListCsv.new(@products).generate
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
