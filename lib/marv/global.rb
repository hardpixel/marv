module Marv
  class Global

    attr_accessor :config, :path, :servers, :plugins, :themes, :layouts

    def initialize(task, from_command=false)
      @task = task

      create_global_folders

      @current = current_options
      @default = default_options

      generate_config(from_command)

      @path = global_path
      @config = global_config
      @servers = local_servers
      @plugins = global_plugins
      @themes = global_themes
      @layouts = global_layouts

      @task.shell.mute do
        clean_broken_links(global_projects_paths)
        link_global_projects
      end
    end

    # Generate configuration
    def generate_config(from_command=false)
      if from_command
        ::File.exists?(config_file) ? reconfigure : configure(from_command)
      else
        configure unless ::File.exists?(config_file)
      end
    end

    # Default config options
    def default_options
      defaults = {
        :server_host  => "localhost",
        :server_port  => "3000",
        :db_user      => "root",
        :db_password  => "root",
        :db_host      => "localhost",
        :db_port      => "3306",
        :wp_version   => "latest",
        :uri          => "https://wordpress.org",
        :author       => username,
        :author_uri   => "https://wordpress.org",
        :license_name => "GPLv3",
        :license_uri  => "http://www.gnu.org/licenses/gpl.html"
      }

      defaults.merge(@current)
    end

    # Get current options
    def current_options
      if ::File.exists?(config_file)
        global_config.reject { |opt| opt.nil? || opt == '' }
      else
        {}
      end
    end

    # Get user name
    def username
      ENV['USERNAME'] || 'marv'
    end

    # Global Marv folder path
    def global_path
      ::File.join(ENV['HOME'], '.marv')
    end

    # Global config file
    def config_file
      ::File.join(::File.join(global_path, 'config.rb'))
    end

    # Load global config file
    def global_config
      if ::File.exists?(config_file)
        load_ruby_config(config_file)
      else
        {}
      end
    end

    # Servers folder path
    def servers_path
      ::File.join(global_path, 'servers')
    end

    # Local servers array
    def local_servers
      @servers = subfolders_basenames(servers_path)
    end

    # Plugins path
    def plugins_path
      ::File.join(global_path, 'plugins')
    end

    # Themes path
    def themes_path
      ::File.join(global_path, 'themes')
    end

    # Layouts path
    def layouts_path
      ::File.join(global_path, 'layouts')
    end

     # Global themes array
    def global_themes
      @themes = subfolders_basenames(themes_path)
    end

    # Global plugins array
    def global_plugins
      @plugins = subfolders_basenames(plugins_path)
    end

    # Global layouts array
    def global_layouts
      @layouts = subfolders_basenames(layouts_path)
    end

    # Create global folders
    def create_global_folders
      @task.shell.mute do
        create_global_path
        create_servers_path
        create_themes_path
        create_plugins_path
        create_layouts_path
      end
    end

    # Create global path
    def create_global_path
      unless ::File.directory?(global_path)
        @task.empty_directory global_path
      end
    end

    # Create servers path
    def create_servers_path
      unless ::File.directory?(servers_path)
        @task.empty_directory servers_path
      end
    end

    # Create themes path
    def create_themes_path
      unless ::File.directory?(themes_path)
        @task.empty_directory themes_path
      end
    end

    # Create plugins path
    def create_plugins_path
      unless ::File.directory?(plugins_path)
        @task.empty_directory plugins_path
      end
    end

    # Create layouts path
    def create_layouts_path
      unless ::File.directory?(layouts_path)
        @task.empty_directory layouts_path
      end
    end

    # Project details
    def ask_project_details
      options = {}

      if @task.said_change?("Do you want to set default project details?")
        options[:uri] = @task.ask_option "Default project URI:", :default => @default[:uri]
        options[:author] = @task.ask_option "Default project author:", :default => @default[:author]
        options[:author_uri] = @task.ask_option "Default project author URI:", :default => @default[:author_uri]
        options[:license_name] = @task.ask_option "Default project license name:", :default => @default[:license_name]
        options[:license_uri] = @task.ask_option "Default project license URI:", :default => @default[:license_uri]
      end

      return options
    end

    # Server details
    def ask_server_details
      options = {}

      if @task.said_change?("Do you want to set default server settings?")
        options[:server_host] = @task.ask_option "Default host for servers:", :default => @default[:server_host]
        options[:server_port] = @task.ask_option "Default port for servers:", :default => @default[:server_port]
      end

      return options
    end

    # Database details
    def ask_database_details
      options = {}

      if @task.said_change?("Do you want to set default database settings?")
        options[:db_user] = @task.ask_option "Default database username:", :default => @default[:db_user]
        options[:db_password] = @task.ask_option "Default database password:", :default => @default[:db_password]
        options[:db_host] = @task.ask_option "Default database host:", :default => @default[:db_host]
        options[:db_port] = @task.ask_option "Default database port:", :default => @default[:db_port]
      end

      return options
    end

    # Wordpress details
    def ask_wordpress_details
      options = {}

      if @task.said_change?("Do you want to set default WordPress version?")
        options[:wp_version] = @task.ask_option "Default WordPress version?", :default => @default[:wp_version]
      end

      return options
    end

    # Get global options
    def global_options
      @options
    end

    # Ask global options
    def ask_global_options
      options = @default

      options.merge!(ask_project_details)
      options.merge!(ask_server_details)
      options.merge!(ask_database_details)
      options.merge!(ask_wordpress_details)

      @options = options
    end

    # Create global config
    def create_global_config
      unless ::File.exists?(config_file)
        @task.shell.mute do
          layout = ::File.join(Marv.root, 'layouts', 'config', 'global.rb')
          filepath = ::File.join(global_path, 'config.rb')

          template layout, filepath, instance_eval('binding')
        end
      end
    end

    # Configure Marv global options
    def configure(from_command=false)
      @task.say_warning "You do not have a global configuration file.", false
      @task.say_info "This will create a new global configuration file.", true

      if @task.said_change?("Do you want to change the default options?")
        ask_global_options
      end

      @options = @default
      create_global_config

      @task.say_success "Global configuration created successfully.", !from_command, true
    end

    # Reconfig Marv global options
    def reconfigure
      @task.say_warning "This will overwrite your global configuration file."

      if @task.said_change?("Do you want to continue?")
        @task.shell.mute do
          ask_global_options

          @task.remove_file config_file
          create_global_config
        end

        @task.say_success "Global configuration recreated successfully.", false, true
      end
    end

    # Global projects paths
    def global_projects_paths
      paths = ::Dir.glob(::File.join(plugins_path, '*'))
      paths = paths + ::Dir.glob(::File.join(themes_path, '*'))

      return paths
    end

    # Global servers paths
    def global_servers_paths
      ::Dir.glob(::File.join(servers_path, '*'))
    end

    # Clean broken global links
    def clean_broken_links(paths)
      paths.each do |path|
        unless ::File.exists?(path)
          ::FileUtils.rm_r path
        end
      end
    end

    # Link global projects
    def link_global_projects
      global_projects_paths.each do |project|
        global_servers_paths.each do |server|
          target = project.gsub(global_path, ::File.join(server, 'wp-content'))
          @task.create_link target, project unless ::File.exists?(target)
        end
      end
    end

    # Load ruby config file
    def load_ruby_config(file)
      config = {}

      begin
        # Config file is just executed as straight ruby
        eval(::File.read(file))
      rescue Exception => e
        @task.say_error "Error while evaluating config file:", e.message
      end

      return config
    end

    # Parse template from source to destination
    def template(source, *args, &block)
      config = args.last.is_a?(Hash) ? args.pop : {}
      destination = args.first || source.sub(/\.tt$/, '')
      context = args.last || instance_eval('binding')

      source  = ::File.expand_path(@task.find_in_source_paths(source.to_s))

      @task.create_file destination, nil, config do
        content = ERB.new(::File.binread(source), nil, '-', '@output_buffer').result(context)
        content = block.call(content) if block
        content
      end
    end

    # Get subfolder basenames
    def subfolders_basenames(folder)
      subfolders = []

      ::Dir.glob(::File.join(folder, '*')).each do |subfolder|
        subfolders << ::File.basename(subfolder)
      end

      return subfolders
    end

  end
end
