module Marv
  class Global

    attr_accessor :config, :path, :servers, :plugins, :themes, :layouts

  	def initialize(task)
  		@task = task
      @path = global_path
      @config = global_config
      @servers = local_servers
      @plugins = global_plugins
      @themes = global_themes
      @layouts = global_layouts
  	end

    # Global Marv folder path
    def global_path
      ::File.join(ENV['HOME'], '.marv')
    end

  	# Load global config file
  	def global_config
      load_ruby_config(::File.join(@path, 'config.rb'))
  	end

    # Servers folder path
    def servers_path
      ::File.join(@path, 'servers')
    end

    # Local servers array
    def local_servers
      @servers = subfolders_basenames(servers_path)
    end

    # Plugins path
    def plugins_path
      ::File.join(@path, 'plugins')
    end

    # Global plugins array
    def global_plugins
      @plugins = subfolders_basenames(plugins_path)
    end

    # Themes path
    def themes_path
      ::File.join(@path, 'themes')
    end

    # Global themes array
    def global_themes
      @themes = subfolders_basenames(themes_path)
    end

    # Layouts path
    def layouts_path
      ::File.join(@path, 'layouts')
    end

    # Global layouts array
    def global_layouts
      @layouts = subfolders_basenames(layouts_path)
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