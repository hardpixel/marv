require 'zip'

module Marv
  module Server
    class Create

      # Initialize server creator
      def initialize(server)
        @server = server
        @task = server.task
        @global = Marv::Global.new(server.task)
        @name = server.name
        @path = server.path
        @database = server.database
        @config = server.config

        create_server
      end

      # Create server
      def create_server
        if ::File.exists?(@server.config_file)
          @task.say_error "A server with the name #{@name} already exists!"
          exit
        end

        begin
          @task.shell.mute do
            create_server_dir
            copy_wordpress_files
            @server.create_database
            add_config_files
          end
        rescue Exception => e
          @task.say_error "Error while creating server:", e.message
          exit
        end

        @task.say_success "Server #{@name} created successfully!"
        start_server
      end

      # Starts the new server
      def start_server
        if @task.yes?("Would you like to start #{@name} server?")
          action = Marv::Server::Actions.new(@server)
          action.start(false)
        end
      end

      # Creates a directory for a new server
      def create_server_dir
        @task.remove_dir @path
        @task.empty_directory @path
      end

      # Downloads WordPress from wordpress.org
      def download_wordpress
        package = "/tmp/wordpress-#{@config[:wp_version]}.zip"
        # Download package file
        if ::File.exists?(package)
          @task.say_warning "WordPress is already downloaded...", false, true
        else ::File.exists?(package)
          @task.say_info "Downloading WordPress...", false, true

          @task.get "https://wordpress.org/wordpress-#{@config[:wp_version]}.zip" do |content|
            @task.create_file package, content
          end
        end
        # Return package file
        package
      end

      # Copy WordPress files
      def copy_wordpress_files
        package = download_wordpress
        tmp_dir = ::File.expand_path "/tmp/wordpress-latest-#{Time.now.to_i}"
        @task.empty_directory tmp_dir unless ::File.directory?(tmp_dir)

        # Extract package to temporary dir
        ::Zip.on_exists_proc = true
        ::Zip::File.open(package) do |zip_file|
          zip_file.each do |entry|
            entry.extract(::File.join(tmp_dir, entry.to_s))
          end
        end

        @task.directory ::File.join(tmp_dir, 'wordpress'), @path
        @task.remove_dir tmp_dir
      end

      # Add configuration files
      def add_config_files
        layouts = ::File.join(Marv.root, 'layouts', 'config')

        @global.template ::File.join(layouts, 'server.rb'), ::File.join(@path, 'config.rb'), @server.context
        @global.template ::File.join(layouts, 'router.php'), ::File.join(@path, 'router.php'), @server.context
        @global.template ::File.join(layouts, 'wp-config.php'), ::File.join(@path, 'wp-config.php'), @server.context
      end

    end
  end
end
