module ScssInitializer
  def self.registered(app)
    require 'sass/plugin/rack'
    Sass::Plugin.options[:syntax] = :scss
    apps = {}
    apps[app] = app.to_s.downcase
    template_locations = {
      Padrino.root("app/stylesheets") => Padrino.root("public/stylesheets"),
      Padrino.root("admin/stylesheets") => Padrino.root("public/admin/stylesheets")
    }
    Sass::Plugin.options[:template_location] = template_locations
    app.use Sass::Plugin::Rack
  end
end
