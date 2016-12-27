Chleehof::App.controllers :products do
  
  get :index, map: '/verpackungsmaterial' do
    @products = Product.ordered
    render :index
  end

  get :show, with: :id, map: '/verpackungsmaterial' do
    @product = Product.find params[:id]
    render :show
  end
  # get :index, :map => '/foo/bar' do
  #   session[:foo] = 'bar'
  #   render 'index'
  # end

  # get :sample, :map => '/sample/url', :provides => [:any, :js] do
  #   case content_type
  #     when :js then ...
  #     else ...
  # end

  # get :foo, :with => :id do
  #   "Maps to url '/foo/#{params[:id]}'"
  # end

  # get '/example' do
  #   'Hello world!'
  # end
  

end
