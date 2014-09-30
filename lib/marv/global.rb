module Marv
  class Global

    attr_accessor :config, :path, :servers, :plugins, :themes, :layouts

    def initialize(task)
      @task = task

      create_global_folders
      create_global_config

      @path = global_path
      @config = global_config
      @servers = local_servers
      @plugins = global_plugins
      @themes = global_themes
      @layouts = global_layouts

      clean_broken_links(global_projects_paths)
      link_global_projects
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
      load_ruby_config(config_file)
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

    # Server details
    def ask_server_details
      options = {}

      if @task.yes?("Do you want to set default server settings?")
        options[:server_host] = @task.ask "Default host for servers?", :default => "localhost"
        options[:server_port] = @task.ask "Default port for servers?", :default => "3000"
      end

      return options
    end

    # Database details
    def ask_database_details
      options = {}

      if @task.yes?("Do you want to set default database settings?")
        options[:db_user] = @task.ask "Default database username?", :default => "root"
        options[:db_password] = @task.ask "Default database password?", :default => "root"
        options[:db_host] = @task.ask "Default database host?", :default => "localhost"
        options[:db_port] = @task.ask "Default database port?", :default => "3306"
      end

      return options
    end

    # Wordpress details
    def ask_wordpress_details
      options = {}

      if @task.yes?("Do you want to set default WordPress version?")
        options[:wp_version] = @task.ask "Default WordPress version?", :default => "latest"
      end

      return options
    end

    # Get global options
    def global_options
      @options
    end

    # Ask global options
    def ask_global_options
      options = {}

      @task.say "This will create a new global configuration file.", :cyan

      if @task.yes?("Do you want to set default project details?")
        options[:uri] = @task.ask "Default project URI"
        options[:author] = @task.ask "Default project author"
        options[:author_uri] = @task.ask "Default project author URI"
        options[:license_name] = @task.ask "Default project license name"
        options[:license_uri] = @task.ask "Default project license URI"
      end

      options.merge!(ask_server_details)
      options.merge!(ask_database_details)
      options.merge!(ask_wordpress_details)

      @options = options
    end

    # Create global config
    def create_global_config
      unless ::File.exists?(config_file)
        ask_global_options
        template ::File.join(Marv.root, 'layouts', 'config', 'global.rb'), ::File.join(global_path, 'config.rb'), instance_eval('binding')
      end
    end

    # Reconfig Marv global options
    def reconfigure
      @task.say "This will overwrite your global configuration file.", :cyan

      if @task.yes?("Do you want to continue?")
        @task.shell.mute do
          @task.remove_file config_file
        end

        create_global_folders
        create_global_config
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
        @task.say "Error while evaluating config file:"
        @task.say e.message, :red
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