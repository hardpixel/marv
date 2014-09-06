require 'net/http'
require 'mysql2'

module Marv
  class Server

    def initialize(project, server, wp_version, mysql_host, mysql_port, mysql_password)
      @server = server
      @project = project
      @task = project.task
      @wp_version = wp_version
      @wp_config = wp_config
      @server_name = project.theme_id
      @server_path = server_path
      @rack_config = rack_config

      @db_password = mysql_password
      @db_host = mysql_host
      @db_port = mysql_port
      @db_name = project.theme_id

      create_server
    end

    def servers_folder
      File.join(ENV['HOME'], '.marv', 'servers')
    end

    def server_path
      File.join(ENV['HOME'], '.marv', 'servers', @project.theme_id)
    end

    def rack_config
      File.join(ENV['HOME'], '.marv', @project.theme_id, 'config.ru')
    end

    def wp_config
      File.join(ENV['HOME'], '.marv', @project.theme_id, 'wp-config.php')
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

    def start_server
      `cd #{server_path}; rackup`
    end

    def create_server
      create_server_directory

      download_wordpress
      extract_wordpress
      add_rack_config

      create_server_database
      add_wordpress_config

      start_server

      @task.say "Server #{@server_name} created.", Thor::Shell::Color::GREEN
    end

    private

    def create_server_directory
      unless File.exist?(self.servers_folder)
        Dir.mkdir(servers_folder)
      end

      if File.exist?(@server_path)
        @task.say "A server with name #{@server_name} already exists.", Thor::Shell::Color::RED
        exit
      end
    end

    def download_wordpress
      if !File.exists?("/tmp/wordpress-#{@wp_version}.tar.gz")
        @task.say "Downloading wordpress-#{@wp_version}.tar.gz..."

        Net::HTTP.start('wordpress.org') do |http|
          resp = http.get("/wordpress-#{@wp_version}.tar.gz")
          open("/tmp/wordpress-#{@wp_version}.tar.gz", 'w') do |file|
            file.write(resp.body)
          end
        end
      end

      @task.say "wordpress-#{@wp_version}.tar.gz downloaded."
    end

    def extract_wordpress
      filestamp = Time.now.to_i
      download_location = File.join('/tmp', "wordpress-#{@wp_version}.tar.gz")
      tmp_dir = "/tmp/wordpress-latest-#{filestamp}"

      Dir.mkdir(tmp_dir)
      `cd #{tmp_dir}; tar -xzf #{download_location}`

      FileUtils.mv("#{tmp_dir}/wordpress", @server_path)
      FileUtils.rm_r(tmp_dir)
    end

    def add_rack_config
      unless File.exists?(@rack_config)
        config_wp = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'layouts', 'config', 'config.wp'))
        config_ru_template = ERB.new(::File.binread(config_wp), nil, '-', '@output_buffer')

        File.open(File.join(@server_path, 'config.ru'), 'w') do |file|
          file.write(config_ru_template.result(binding))
        end
      end
    end

    def create_server_database
      client = Mysql2::Client.new(:host => @db_host, :port => @db_port, :username => "root", :password => @db_password)
      client.query("CREATE DATABASE IF NOT EXISTS #{@db_name}")
      client.query("GRANT ALL PRIVILEGES ON #{@db_name}.* TO 'root'@'localhost'")
      client.query("FLUSH PRIVILEGES")
      client.close

      @task.say "Mysql database created."
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

  end
end