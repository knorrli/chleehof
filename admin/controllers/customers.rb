Chleehof::Admin.controllers :customers do

  get :search, :provides => [:html, :json] do
    @results = Customer.search params[:q]
    @results.to_json
  end


  get :index do
    @customers = Customer.all
    render 'customers/index'
  end

  get :new do
    @customer = Customer.new
    render 'customers/new'
  end

  post :create do
    @customer = Customer.new(params[:customer])
    if @customer.save
      flash[:success] = "Kunde #{@customer.name} wurde gespeichert"
      redirect(url_for(:customers, :index))
    else
      @title = pat(:create_title, :model => 'customer')
      flash.now[:error] = "Kunde #{@customer.name} kann nicht gespeichert werden"
      render 'customers/new'
    end
  end

  get :edit, :with => :id do
    @customer = Customer.find(params[:id])
    render 'customers/edit'
  end

  put :update, with: :id do
    @customer = Customer.find(params[:id])
    @customer.assign_attributes(params[:customer])
    if @customer.valid?
      @customer.save
      flash[:success] = "Kunde #{@customer.name} wurde angepasst"
      redirect(url_for(:customers, :index))
    else
      flash.now[:error] = "Kunde #{@customer.name} kann nicht angepasst werden"
      render 'customers/edit'
    end
  end

  delete :destroy, with: :id do
    @customer = Customer.find(params[:id])
    @customer.destroy
    flash[:success] = "Kunde #{@customer.name} wurde gelöscht"
    redirect(url(:customers, :index))
  end
end

