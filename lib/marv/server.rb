require 'net/http'
require 'mysql2'
require 'childprocess'

module Marv
  class Server

    def initialize(name, config, options)
      @task = config

      # Deploy variables
      @server_name = name
      @server_path = server_path
      @db_name = 'marv_'+name.gsub(/\W/, '_').downcase

      # CLI Options
      unless options.nil?
        if options[:password] == "required"
          @task.say "Mysql password is required. Aborting...", :red
          abort
        end

        @wp_version = options[:version]
        @db_user = options[:user]
        @db_password = options[:password]
        @db_host = options[:host]
        @db_port = options[:port]
      end
    end

    def servers_root
      File.join(ENV['HOME'], '.marv', 'servers')
    end

    def server_path
      File.join(ENV['HOME'], '.marv', 'servers', @server_name)
    end

    def db_name
      @db_name
    end

    def db_password
      @db_password
    end

    def db_host
      @db_host
    end

    def run_php_server
      # Setup server
      server = TCPServer.new('0.0.0.0', 0)
      port = server.addr[1]
      server.close()

      # Run PHP server
      @php = ChildProcess.build 'php', '-S', "0.0.0.0:#{port}", '-t', @server_path
      @php.start

      # Write PHP proccess id to file
      File.open(File.join(@server_path, 'php.pid'), 'w') do |file|
        file.write(@php.pid)
      end

      puts "Visit http://localhost:#{port}"
    end

    def create_server
      create_server_directory

      copy_wordpress_files
      add_config_file('router.php.erb', 'router.php')

      create_server_database
      add_config_file('wp-config.php.erb', 'wp-config.php')

      add_global_content

      @task.say "Server #{@server_name} created successfuly!", :green
      @task.say "Start server using marv server #{@server_name} --start"
      exit
    end

    def start_server
      begin
        update_global_projects
        run_php_server
      rescue Exception => e
        @task.say "Error while starting server:"
        @task.say e.message + "\n", :red
      end
      @task.say "Server #{@server_name} running", :green
    end

    def stop_server
      begin
        @task.shell.mute do
          php_pid_file = File.join(@server_path, 'php.pid')

          if File.exists?(php_pid_file)
            php_pid = File.read(php_pid_file).to_i

            Process.kill('KILL', php_pid)
            @task.say "Server #{@server_name} stopped", :yellow
          else
            @task.say "Server #{@server_name} is not running", :red
          end
        end
      rescue Exception => e
        @task.say "Error while stoping server:"
        @task.say e.message + "\n", :red
      end
    end

    def restart_server
      stop_server
      start_server
    end

    def remove_server
      @task.say "Removing server..."
      @task.shell.mute do
        stop_server
      end
      @task.say "Removing server files..."

      begin
        @task.shell.mute do
          FileUtils.rm_r(@server_path)
        end
        @task.say "Server files removed", :green
      rescue Exception => e
        @task.say "Error while removing server files:"
        @task.say e.message + "\n", :red
      end

      remove_server_database

      @task.say "Server successfuly removed!", :green
      exit
    end

    private

    # Creates a directory for a new server
    def create_server_directory
      # Create dir
      unless ::File.exist?(self.servers_root)
        ::Dir.mkdir(servers_root)
      end
      # Exit if dir exists
      if ::File.exist?(@server_path)
        @task.say "A server with name #{@server_name} already exists", :red
        exit
      end
    end

    # Downloads WordPress from wordpress.org
    def download_wordpress
      package = "/tmp/wordpress-#{@wp_version}.tar.gz"

      # Download package file
      @task.shell.mute do
        unless ::File.exists?(package)
          @task.get "https://wordpress.org/wordpress-#{@wp_version}.tar.gz" do |content|
            @task.create_file package, content
          end
        end
      end

      # Return package file
      package
    end

    # Copy WordPress files
    def copy_wordpress_files
      package = download_wordpress

      # Get package content and extract to dir
      tmp_dir = "/tmp/wordpress-latest-#{Time.now.to_i}"
      # Create temporary dir
      unless ::File.exists?(tmp_dir)
        Dir.mkdir(tmp_dir)
      end

      # Extract package to temporary dir
      @task.shell.mute do
        @task.run "cd #{tmp_dir};tar -xzf #{package}"
        @task.directory "#{tmp_dir}/wordpress", @server_path
      end

      # Remove temporary dir
      if ::File.exists?(tmp_dir)
        FileUtils.rm_r(tmp_dir)
      end
    end

    def add_config_file(source, target)
      unless File.exists?(target)
        config = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'layouts', 'config', source))
        config_template = ERB.new(::File.binread(config), nil, '-', '@output_buffer')

        File.open(File.join(@server_path, target), 'w') do |file|
          file.write(config_template.result(binding))
        end
      end
    end

    def create_server_database
      begin
        @task.shell.mute do
          client = Mysql2::Client.new(:host => @db_host, :port => @db_port, :username => @db_user, :password => @db_password)
          client.query("CREATE DATABASE IF NOT EXISTS #{@db_name}")
          client.query("GRANT ALL PRIVILEGES ON #{@db_name}.* TO '#{@db_user}'@'#{@db_host}'")
          client.query("FLUSH PRIVILEGES")
          client.close
        end
      rescue Exception => e
        @task.say "Error while creating Mysql database:"
        @task.say e.message + "\n", :red
        exit
      end
    end

    def remove_server_database
      begin
        @task.shell.mute do
          client = Mysql2::Client.new(:host => @db_host, :port => @db_port, :username => @db_user, :password => @db_password)
          client.query("DROP DATABASE IF EXISTS #{@db_name}")
          client.query("REVOKE ALL PRIVILEGES ON #{@db_name}.* FROM '#{@db_user}'@'#{@db_host}'")
          client.query("FLUSH PRIVILEGES")
          client.close
        end
      rescue Exception => e
        @task.say "Error while removing Mysql database:"
        @task.say e.message + "\n", :red
      end
    end

    def add_global_content
      @task.shell.mute do
        global = File.join(ENV['HOME'], '.marv')
        themes = Dir.glob(File.join(global, 'themes', '*'))

        themes.each do |theme|
          @task.create_link File.join(@server_path, 'wp-content', 'themes', File.basename(theme)), theme
        end

        plugins = Dir.glob(File.join(global, 'plugins', '*'))

        plugins.each do |plugin|
          @task.create_link File.join(@server_path, 'wp-content', 'plugins', File.basename(plugin)), plugin
        end
      end
    end

    def update_global_folders(dir, folders)
      begin
        folders.each do |folder|
          if File.symlink?(folder)
            unless File.exists?(folder)
              File.delete(folder)
              File.delete(File.join(ENV['HOME'], '.marv', dir, File.basename(folder)))
            end
          end
        end
      rescue Exception => e
        @task.say "Error while updating global projects:"
        @task.say e.message + "\n", :red
      end
    end

    def update_global_projects
      themes = Dir.glob(File.join(@server_path, 'wp-content', 'themes', '*'))
      update_global_folders('themes', themes)

      plugins = Dir.glob(File.join(@server_path, 'wp-content', 'plugins', '*'))
      update_global_folders('plugins', plugins)
    end

  end
end