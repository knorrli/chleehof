# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:

server "185.48.228.40", user: "dreiradfahrer", roles: %w{app db web}
