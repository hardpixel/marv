require 'mysql2'

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
        @options = server_options
        @config = server_config
        @host = server_host
        @port = server_port
        @database = server_database
        @context = server_context
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

      # Ask for server details
      def server_options
        options = {}

        unless ::File.exists?(@config_file)
          # Server details
          options[:server_host] = @task.ask "Where do you want to run the server?", :default => "localhost"
          options[:server_port] = @task.ask "Which port do you want to use?", :default => "3000"
          # Database details
          options[:db_user] = @task.ask "MySQL database username?", :default => "root" unless @global.config[:db_user]
          options[:db_password] = @task.ask "MySQL database password?", :default => "root" unless @global.config[:db_password]
          options[:db_host] = @task.ask "MySQL database host?", :default => "localhost" unless @global.config[:db_host]
          options[:db_port] = @task.ask "MySQL database port?", :default => "3306" unless @global.config[:db_port]
          # Wordpress details
          options[:wp_version] = @task.ask "WordPress version to install?", :default => "latest" unless @global.config[:wp_version]
        end

        return options
      end

      # Server database
      def server_database
        ::Mysql2::Client.new(:host => db_host, :port => db_port, :username => db_user, :password => db_password)
      end

      # Get server class context
      def server_context
        instance_eval('binding')
      end

    end
  end
end