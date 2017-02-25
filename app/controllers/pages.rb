Chleehof::App.controllers :pages do

  get :home, map: '/home' do
    render 'home'
  end

  get :betrieb, map: '/betrieb' do
    render 'betrieb'
  end

  get :lehrstelle, map: '/lehrstelle' do
    render 'lehrstelle'
  end

  get :lohnarbeiten, map: '/lohnarbeiten' do
    render 'lohnarbeiten'
  end

  get :kulturen, map: '/kulturen' do
    render 'kulturen'
  end

  get :schule, map: '/schule' do
    render 'schule'
  end
end
