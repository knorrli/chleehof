Chleehof::Admin.controllers :base do
  get :admin, :map => "/admin" do
    redirect_to '/'
  end
end
