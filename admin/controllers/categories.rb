Chleehof::Admin.controllers :categories do
  
  get :index do
    @categories = Category.ordered
    render 'index'
  end

  get :new do
    @category = Category.new
    render 'new'
  end

  post :create do
    @category = Category.new(params[:category])
    if @category.save
      flash[:success] = "#{@category} wurde gespeichert"
      redirect(url(:categories, :index))
    else
      flash.now[:error] = "#{@category} konnte nicht gespeichert werden"
      render 'new'
    end
  end

  get :edit, :with => :id do
    @category = Category.find(params[:id])
    render 'edit'
  end

  put :update, :with => :id do
    @category = Category.find(params[:id])
    @category.assign_attributes(params[:category])
    if @category.valid?
      @category.save
      flash[:success] = "Kategorie #{@category.name} wurde angepasst"
      redirect(url_for(:categories, :index))
    else
      flash.now[:error] = "Kategorie #{@category.name} kann nicht angepasst werden"
      render 'edit'
    end
  end

  delete :destroy, with: :id do
    @category = Category.find(params[:id])
    @category.destroy
    flash[:success] = "Kategorie #{@category.name} wurde gelöscht"
    redirect(url(:categories, :index))
  end
end
