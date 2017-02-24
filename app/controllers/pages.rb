Chleehof::App.controllers :pages do

  get :home, map: '/home' do
    render 'home'
  end

  get :about, map: '/about' do
    render 'about'
  end

  get :lehrstelle, map: '/lehrstelle' do
    render 'lehrstelle'
  end

  get :lohnarbeiten, map: '/lohnarbeiten' do
    render 'lohnarbeiten'
  end

  get :schule, map: '/schule' do
    render 'schule'
  end
end
