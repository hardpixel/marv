require 'mysql2'

require 'marv/server/actions'
require 'marv/server/create'

module Marv
  module Server
    class Server

      attr_accessor :task, :name, :path, :config, :host, :port, :database, :context

      # Initialize server config
      def initialize(task, dir)
        @task = task
        @global = Marv::Global.new(task)
        @name = dir
        @path = server_path
        @config_file = config_file
        @options = {}
        @config = server_config
        @host = server_host
        @port = server_port
        @database = db_client
        @context = server_context

        @global.clean_broken_links(server_projects_paths)
      end

      # Server exists
      def exists?
        ::File.exists?(server_path)
      end

      # Server path
      def server_path
      	::File.join(@global.servers_path, @name)
      end

      # Config file
      def config_file
        ::File.join(server_path, 'config.rb')
      end

      # Database name
      def db_name
        'marv_'+@name.gsub(/\W/, '_').downcase
      end

      # Database username
      def db_user
        @config[:db_user]
      end

      # Database user password
      def db_password
        @config[:db_password]
      end

      # Database host
      def db_host
        @config[:db_host]
      end

      # Database port
      def db_port
        @config[:db_port]
      end

      # Wordpress version
      def wp_version
        @config[:wp_version]
      end

      # Server host
      def server_host
        @config[:server_host]
      end

      # Server port
      def server_port
        @config[:server_port]
      end

      # Server config file
      def server_config
        config = @global.config

        # Check for user options
        unless @options.nil?
          config.merge!(@options)
        end

        # Check for config.rb in server folder
        if ::File.exists?(@config_file)
          config.merge!(@global.load_ruby_config(@config_file))
        end

        return config
      end

      # Ask for server options
      def server_options
        options = {}

        unless ::File.exists?(@config_file)
          @task.say_info "This will create a new development server."
          @task.say_warning "Please enter server settings below:"

          options.merge!(ask_server_details)
          options.merge!(ask_database_details)
          options.merge!(ask_wordpress_details)
        end

        return options
      end

      # Server details
      def ask_server_details
        options = {}
        options[:server_host] = @task.ask_input "Where do you want to run the server?", :default => @global.config[:server_host]
        options[:server_port] = @task.ask_input "Which port do you want to use?", :default => @global.config[:server_port]

        return options
      end

      # Database details
      def ask_database_details
        options = {}
        options[:db_user] = @task.ask_input "MySQL database username:", :default => @global.config[:db_user]
        options[:db_password] = @task.ask_input "MySQL database password:", :default => @global.config[:db_password]
        options[:db_host] = @task.ask_input "MySQL database host:", :default => @global.config[:db_host]
        options[:db_port] = @task.ask_input "MySQL database port:", :default => @global.config[:db_port]

        return options
      end

      # Wordpress details
      def ask_wordpress_details
        options = {}
        options[:wp_version] = @task.ask_input "WordPress version to install:", :default => @global.config[:wp_version]

        return options
      end

      # Server database
      def db_client
        begin
          ::Mysql2::Client.new(:host => db_host, :port => db_port, :username => db_user, :password => db_password)
        rescue Mysql2::Error::ConnectionError
          @task.say_error "Not able to connect to the database.", "Start the database if it is not running.", false
          abort
        end
      end

      # MySQL create database
      def db_client_create
        @database.query("CREATE DATABASE IF NOT EXISTS #{db_name}")
      end

      # MySQL create database
      def db_client_drop
        @database.query("DROP DATABASE IF EXISTS #{db_name}")
      end

      # MySQL grant all privileges
      def db_client_grant_all
        @database.query("GRANT ALL PRIVILEGES ON #{db_name}.* TO '#{db_user}'@'#{db_host}'")
      end

      # MySQL revoke all privileges
      def db_client_revoke_all
        @database.query("REVOKE ALL PRIVILEGES ON #{db_name}.* FROM '#{db_user}'@'#{db_host}'")
      end

      # MySQL flush privileges
      def db_client_flush_priv
        @database.query("FLUSH PRIVILEGES")
      end

      # Create MySQL database
      def create_database
        begin
          db_client_create
          db_client_grant_all
          db_client_flush_priv
          @database.close
        rescue Exception => e
          @task.say_error "An error occured while creating the database:", e.message, false, true
        end
      end

      # Remove MySQL database
      def remove_database
        begin
          db_client_drop
          db_client_revoke_all
          db_client_flush_priv
          @database.close
        rescue Exception => e
          @task.say_error "An error occured while removing the database:", e.message, false, true
        end
      end

      # Get server class context
      def server_context
        instance_eval('binding')
      end

      # Server projects paths
      def server_projects_paths
        paths = ::Dir.glob(::File.join(server_path, 'wp-content', 'themes', '*'))
        paths = paths + ::Dir.glob(::File.join(server_path, 'wp-content', 'plugins', '*'))

        return paths
      end

    end
  end
end
