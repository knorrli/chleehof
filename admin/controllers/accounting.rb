Chleehof::Admin.controllers :accounting do

  get :index do
    if year = params[:year]
      @accounting = Presenters::Accounting.new year: year
    else
      @accounting = Presenters::Accounting.new
    end
    render 'accounting/index'
  end

end
