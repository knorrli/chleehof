Chleehof::App.controllers :pages do

  get :home, map: '/home' do
    render 'home'
  end

  get :betrieb, map: '/betrieb' do
    render 'betrieb'
  end

  get :kontakt, map: '/kontakt' do
    render 'kontakt'
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

  get :formular, map: '/formular', provides: :pdf do
    send_file File.expand_path('formular.pdf', settings.public_folder)
  end
end
