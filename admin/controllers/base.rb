Chleehof::Admin.controllers :base do
  get :index do
    redirect_to '/'
  end

  get :admin, :map => "/admin" do
    redirect_to '/'
  end
end
