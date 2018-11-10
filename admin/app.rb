require 'active_support/core_ext/object/blank'

module Chleehof
  class Admin < Padrino::Application
    register ScssInitializer
    use ConnectionPoolManagement
    register Padrino::Mailer
    register Padrino::Helpers
    register Padrino::Admin::AccessControl
    use Rack::Session::Cookie,
      :key => 'rack.login',
      # :domain => 'luethi-chleehof.ch',
      :path => '/',
      :expire_after => 1825 * 86400, # In seconds
      :secret => '61e5613ba84810ec0f3b919a2a582b5c53cd23cb1b9ad1951b575f195895dd4b'

    disable :store_location
    layout :application

    ##
    # Application configuration options
    #
    # set :raise_errors, true         # Raise exceptions (will stop application) (default for test)
    # set :dump_errors, true          # Exception backtraces are written to STDERR (default for production/development)
    set :show_exceptions, true      # Shows a stack trace in browser (default for development)
    # set :logging, true                # Logging in STDOUT for development and file for production (default only for development)
    # set :public_folder, "foo/bar"   # Location for static assets (default root/public)
    # set :reload, false              # Reload application files (default in development)
    # set :default_builder, "foo"     # Set a custom form builder (default 'StandardFormBuilder')
    # set :locale_path, "bar"         # Set path for I18n translations (default your_app/locales)
    # disable :sessions               # Disabled sessions by default (enable if needed)
    # disable :flash                  # Disables sinatra-flash (enabled by default if Sinatra::Flash is defined)
    # layout  :my_layout              # Layout can be in views/layouts/foo.ext or views/foo.ext (default :application)
    #

    set :admin_model, 'Account'
    set :login_page,  '/sessions/new'

    access_control.roles_for :any do |role|
      role.protect '/'
      role.allow   '/sessions'
    end

    get '/' do
      redirect_to url(:orders, :new)
    end

    access_control.roles_for :admin do |role|
      role.project_module :orders, '/orders'
      role.project_module :products, '/products'
      role.project_module :accounts, '/accounts'
      role.project_module :accounting, '/accounting'
    end

    # Custom error management 
    error(403) { @title = "Error 403"; render('errors/403', :layout => :error) }
    error(404) { @title = "Error 404"; render('errors/404', :layout => :error) }
    error(500) { @title = "Error 500"; render('errors/500', :layout => :error) }
  end
end
