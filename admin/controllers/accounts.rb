Chleehof::Admin.controllers :accounts do

  get :edit, :with => :id do
    @account = Account.find_by(id: params[:id])
    if @account
      render 'accounts/edit'
    else
      halt 404
    end
  end

  put :update, :with => :id do
    @account = Account.find(params[:id])
    if @account
      if @account.update_attributes(params[:account])
        flash[:success] = "Einstellungen wurden gespeichert"
        redirect(url(:orders, :new))
      else
        flash.now[:error] = "Einstellungen konnten nicht gespeichert werden"
        render 'accounts/edit'
      end
    else
      halt 404
    end
  end
end
