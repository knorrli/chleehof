ActiveRecord::Base.configurations = {
  development: {
    :adapter   => 'postgresql',
    :database  => ENV.fetch('DATABASE_NAME', 'chleehof'),
    :username => ENV.fetch('DATABASE_USERNAME', 'igor'),
    :password  => ENV.fetch('DATABASE_PASSWORD', 'password'),
    :host      => ENV.fetch('DATABASE_HOST', '127.0.0.1'),
    :port      => ENV.fetch('DATABASE_PORT', 5432)
  },
  production: {
    :adapter   => 'postgresql',
    :database  => 'chleehof',
    :username  => 'chleehof',
    :password  => ENV['CHLEEHOFDB_PW'],
    :host      => '127.0.0.1',
    :port      => 5432
  }
}

# Setup our logger
ActiveRecord::Base.logger = logger

if ActiveRecord::VERSION::MAJOR.to_i < 4
  # Raise exception on mass assignment protection for Active Record models.
  ActiveRecord::Base.mass_assignment_sanitizer = :strict

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL).
  ActiveRecord::Base.auto_explain_threshold_in_seconds = 0.5
end

# Doesn't include Active Record class name as root for JSON serialized output.
ActiveRecord::Base.include_root_in_json = false

# Store the full class name (including module namespace) in STI type column.
ActiveRecord::Base.store_full_sti_class = true

# Use ISO 8601 format for JSON serialized times and dates.
ActiveSupport.use_standard_json_time_format = true

# Don't escape HTML entities in JSON, leave that for the #json_escape helper
# if you're including raw JSON in an HTML page.
ActiveSupport.escape_html_entities_in_json = false

# Now we can establish connection with our db.
ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations[Padrino.env])

# Timestamps are in the utc by default.
ActiveRecord::Base.default_timezone = :utc
