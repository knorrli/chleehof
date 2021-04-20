##
# This file mounts each app in the Padrino project to a specified sub-uri.
# You can mount additional applications using any of these commands below:
#
#   Padrino.mount('blog').to('/blog')
#   Padrino.mount('blog', :app_class => 'BlogApp').to('/blog')
#   Padrino.mount('blog', :app_file =>  'path/to/blog/app.rb').to('/blog')
#
# You can also map apps to a specified host:
#
#   Padrino.mount('Admin').host('admin.example.org')
#   Padrino.mount('WebSite').host(/.*\.?example.org/)
#   Padrino.mount('Foo').to('/foo').host('bar.example.org')
#
# Note 1: Mounted apps (by default) should be placed into the project root at '/app_name'.
# Note 2: If you use the host matching remember to respect the order of the rules.
#
# By default, this file mounts the primary app which was generated with this project.
# However, the mounted app can be modified as needed:
#
#   Padrino.mount('AppName', :app_file => 'path/to/file', :app_class => 'BlogApp').to('/')
#

##
# Setup global project settings for your apps. These settings are inherited by every subapp. You can
# override these settings in the subapps as needed.
#
Padrino.configure_apps do
	# use Rack::Session::Pool, :expire_after => 1825 * 86400 # 5 years = 1825 days in seconds

  set :session_secret, '61e5613ba84810ec0f3b919a2a582b5c53cd23cb1b9ad1951b575f195895dd4b'
  set :protection, :except => :path_traversal
  # set :protect_from_csrf, true

  disable :reload
  enable :reload
end

# Mounts the core application for this project

Padrino.mount("Chleehof::Admin", :app_file => Padrino.root('admin/app.rb')).to("/")
