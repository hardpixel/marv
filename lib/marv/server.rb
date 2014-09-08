require 'net/http'
require 'mysql2'

module Marv
  class Server

    def initialize(name, config, options)
      @task = config

      # Deploy variables
      @server_name = name
      @server_path = server_path

      @rack_config = rack_config
      @wp_config = wp_config

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

    def rack_config
      File.join(ENV['HOME'], '.marv', @server_path, 'config.ru')
    end

    def wp_config
      File.join(ENV['HOME'], '.marv', @server_path, 'wp-config.php')
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

    def create_server
      create_server_directory

      download_wordpress
      extract_wordpress
      add_rack_config

      create_server_database
      add_wordpress_config

      add_global_content

      @task.say "Server #{@server_name} created", :green
      exit
    end

    def start_server
      update_global_content

      begin
        @task.shell.mute do
          system("cd #{server_path}; rackup --daemonize --pid=ruby.pid")
        end
      rescue Exception => e
        @task.say "Error while starting server:"
        @task.say e.message + "\n", :red
        exit
      end
      @task.say "Server #{@server_name} running", :green
    end

    def stop_server
      begin
        @task.shell.mute do
          ruby_pid_file = File.join(@server_path, 'ruby.pid')
          php_pid_file = File.join(@server_path, 'php.pid')

          if File.exist?(ruby_pid_file) && File.exist?(php_pid_file) then
            ruby_pid = File.read(ruby_pid_file).to_i
            php_pid = File.read(php_pid_file).to_i

            Process.kill(9, ruby_pid, php_pid)
            @task.say "Server #{@server_name} stopped", :green
          else
            @task.say "Server #{@server_name} is not running", :yellow
          end
        end
      rescue Exception => e
        @task.say "Error while stoping server:"
        @task.say e.message + "\n", :red
        exit
      end
    end

    def restart_server
      stop_server
      start_server
    end

    def remove_server
      @task.say "Removing server...", :green
      @task.shell.mute do
        stop_server
      end
      @task.say "Removing server files...", :green

      begin
        @task.shell.mute do
          FileUtils.rm_r(@server_path)
        end
      rescue Exception => e
        @task.say "Error while removing server files:"
        @task.say e.message + "\n", :red
      end

      remove_server_database

      @task.say "Server successfuly removed", :yellow
      exit
    end

    private

    def create_server_directory
      unless File.exist?(self.servers_root)
        Dir.mkdir(servers_root)
      end

      if File.exist?(@server_path)
        @task.say "A server with name #{@server_name} already exists", :red
        exit
      end
    end

    def download_wordpress
      @task.say "Starting server installation:", :green

      begin
        @task.shell.mute do
          if !File.exists?("/tmp/wordpress-#{@wp_version}.tar.gz")
            @task.say "Downloading wordpress-#{@wp_version}.tar.gz..."

            Net::HTTP.start('wordpress.org') do |http|
              resp = http.get("/wordpress-#{@wp_version}.tar.gz")
              open("/tmp/wordpress-#{@wp_version}.tar.gz", 'w') do |file|
                file.write(resp.body)
              end
            end
          end
        end
      rescue Exception => e
        @task.say "Error while downloading wordpress-#{@wp_version}.tar.gz:"
        @task.say e.message + "\n", :red
        exit
      end
      @task.say "wordpress-#{@wp_version}.tar.gz downloaded"
    end

    def extract_wordpress
      begin
        @task.shell.mute do
          filestamp = Time.now.to_i
          download_location = File.join('/tmp', "wordpress-#{@wp_version}.tar.gz")
          tmp_dir = "/tmp/wordpress-latest-#{filestamp}"

          Dir.mkdir(tmp_dir)
          `cd #{tmp_dir}; tar -xzf #{download_location}`

          FileUtils.mv("#{tmp_dir}/wordpress", @server_path)
          FileUtils.rm_r(tmp_dir)
        end
      rescue Exception => e
        @task.say "Error while extracting wordpress-#{@wp_version}.tar.gz:"
        @task.say e.message + "\n", :red
        exit
      end
    end

    def add_wordpress_config
      unless File.exists?(@wp_config)
        wp_config = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'layouts', 'config', 'wp-config.php.erb'))
        wp_config_template = ERB.new(::File.binread(wp_config), nil, '-', '@output_buffer')

        File.open(File.join(@server_path, 'wp-config.php'), 'w') do |file|
          file.write(wp_config_template.result(binding))
        end
      end
    end

    def add_rack_config
      unless File.exists?(@rack_config)
        config_wp = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'layouts', 'config', 'rack-config.ru'))
        config_ru_template = ERB.new(::File.binread(config_wp), nil, '-', '@output_buffer')

        File.open(File.join(@server_path, 'config.ru'), 'w') do |file|
          file.write(config_ru_template.result(binding))
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
      @task.say "Mysql database created", :green
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
        exit
      end
      @task.say "Mysql database removed", :yellow
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

    def update_global_content
      @task.shell.mute do
        themes = Dir.glob(File.join(@server_path, 'wp-content', 'themes', '*'))

        themes.each do |theme|
          if File.symlink?(theme)
            unless File.exists?(theme)
              File.delete(theme)
              File.delete(File.join(ENV['HOME'], '.marv', 'themes', File.basename(theme)))
            end
          end
        end

        plugins = Dir.glob(File.join(@server_path, 'wp-content', 'plugins', '*'))

        plugins.each do |plugin|
          if File.symlink?(plugin)
            unless File.exists?(plugin)
              File.delete(plugin)
              File.delete(File.join(ENV['HOME'], '.marv', 'themes', File.basename(plugin)))
            end
          end
        end
      end
    end

  end
end