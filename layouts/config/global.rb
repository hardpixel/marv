# Marv server configuration
config[:server_host] = "<%= global_options[:server_host] %>"
config[:server_port] = "<%= global_options[:server_port] %>"

# Database configuration
config[:db_user] = "<%= global_options[:db_user] %>"
config[:db_password] = "<%= global_options[:db_password] %>"
config[:db_host] = "<%= global_options[:db_host] %>"
config[:db_port] = "<%= global_options[:db_port] %>"
config[:wp_version] = "<%= global_options[:wp_version] %>"

# WordPress theme/plugin information
config[:uri] = "<%= global_options[:uri] %>"
config[:author] = "<%= global_options[:author] %>"
config[:author_uri] = "<%= global_options[:author_uri] %>"
config[:license_name] = "<%= global_options[:license_name] %>"
config[:license_uri] = "<%= global_options[:license_uri] %>"

# Assets compression
# config[:compress_js] = true
# config[:compress_css] = true

# Enable livereload
# config[:livereload] = true

# Additional assets
# config[:additional_assets] = [['custom.js'], ['stylesheets', 'custom.css'], ['includes', 'javascripts', 'includes.js']]

# You can also include additional frameworks by requiring them:
# require 'bourbon'
# require 'neat'