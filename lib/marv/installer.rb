require 'net/http'

module Marv
  class Installer

    def initialize(dir, wordpress)
      @install_path = dir
      @wp_version = wordpress
      @rack_config = File.join(dir, 'config.ru')

      new_install
    end

    private

    def new_install
      create_project_directory

      download_wordpress
      extract_wordpress_into_project_directory
      add_rack_config

      puts "WordPress installation created at #{@install_path}."
    end

    def create_project_directory
      if File.exist?(@install_path)
        puts "A file or directory with name #{@install_path} already exists."
        exit 1
      end
    end

    def download_wordpress
      if !File.exists?("/tmp/wordpress-#{@wp_version}.tar.gz")
        puts "Downloading wordpress-#{@wp_version}.tar.gz..."

        Net::HTTP.start('wordpress.org') do |http|
          resp = http.get("/wordpress-#{@wp_version}.tar.gz")
          open("/tmp/wordpress-#{@wp_version}.tar.gz", 'w') do |file|
            file.write(resp.body)
          end
        end
      end

      puts "wordpress-#{@wp_version}.tar.gz downloaded."
    end

    def extract_wordpress_into_project_directory
      filestamp = Time.now.to_i
      download_location = File.join('/tmp', "wordpress-#{@wp_version}.tar.gz")
      tmp_dir = "/tmp/wordpress-latest-#{filestamp}"

      Dir.mkdir(tmp_dir)
      `cd #{tmp_dir}; tar -xzf #{download_location}`

      FileUtils.mv("#{tmp_dir}/wordpress", @install_path)
      FileUtils.rm_r(tmp_dir)
    end

    def add_rack_config
      unless File.exists?(@rack_config)
        config_wp = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'layouts', 'config', 'config.wp'))
        config_ru_template = ERB.new(::File.binread(config_wp), nil, '-', '@output_buffer')

        puts "Adding config.ru for usage with Rack Server."

        File.open(File.join(@install_path, 'config.ru'), 'w') do |file|
          file.write(config_ru_template.result(binding))
        end

      end
    end

  end
end