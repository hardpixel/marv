module Marv
  module Project
    class Config

      attr_accessor :root, :config, :task, :assets

      # Initialize project config
      def initialize(task, dir, options)
        @task = task
        @dir = dir
        @global = Marv::Global.new(task)
        @options = options
        @name = project_name
        @id = project_id
        @root = root_path
        @config_file = config_file
        @config = project_config
        @assets = project_assets
      end

      # Project name
      def project_name
        ::File.basename(@dir).gsub(/\W/, ' ').capitalize
      end

      # Project URI
      def project_uri
        project_config[:uri]
      end

      # Project author
      def project_author
        project_config[:author]
      end

      # Project author URI
      def project_author_uri
        project_config[:author_uri]
      end

      # Project description
      def project_description
        project_config[:description]
      end

      # Project version
      def project_version
        project_config[:version]
      end

      # Project template
      def project_template
        project_config[:template]
      end

      # Project license_name
      def project_license_name
        project_config[:license_name]
      end

      # Project license URI
      def project_license_uri
        project_config[:license_uri]
      end

      # Project tags
      def project_tags
        project_config[:tags]
      end

      # Project comments
      def project_comments
        project_config[:comments]
      end

      # Project id
      def project_id
        project_name.gsub(' ', '_').downcase
      end

      # Project root path
      def root_path
        ::File.expand_path(@dir)
      end

      # Project source path
      def source_path
        ::File.join(root_path, 'source')
      end

      # Project watch path
      def watch_path
        ::File.join(root_path, '.watch', 'build')
      end

      # Project build path
      def build_path
        ::File.join(root_path, 'build')
      end

      # Project package path
      def package_path
        ::File.join(root_path, 'package')
      end

      # Project assets path
      def assets_path
        ::File.join(source_path, 'assets')
      end

      # Project functions path
      def functions_path
        ::File.join(source_path, 'functions')
      end

      # Project templates path
      def templates_path
        ::File.join(source_path, 'templates')
      end

      # Project includes path
      def includes_path
        ::File.join(source_path, 'includes')
      end

      # Config file
      def config_file
        ::File.join(root_path, 'config.rb')
      end

      # Plugin php file
      def plugin_file
        ::File.join(functions_path, "#{project_id.gsub('_', '-')}.php")
      end

      # Theme functions file
      def functions_file
        ::File.join(functions_path, 'functions.php')
      end

      # Project config file
      def project_config
        project_config = @config_file
        config = {}

        # Add project name
        config[:name] = @name

        # Merge global config
        config.merge!(@global.config)

        # Check for config file in options
        unless @opt_config.nil?
          project_config = ::File.expand_path(@opt_config)
        end

        # Check for config.rb in project folder
        if ::File.exists?(project_config)
          config.merge!(@global.load_ruby_config(project_config))
        else
          @task.say "Could not find the config file!", :red
          @task.say "Are you sure you're in a marv project directory?"
          abort
        end

        return config
      end

      # Get all project assets
      def project_assets
        assets = [
          ['style.css'],
          ['plugin.css'],
          ['admin.css'],
          ['javascripts', 'theme.js'],
          ['javascripts', 'plugin.js'],
          ['javascripts', 'admin.js']
        ]

        if project_config[:additional_assets]
          assets = assets | project_config[:additional_assets]
        end
      end

      # Parse template from source to destination
      def template(source, *args, &block)
        config = args.last.is_a?(Hash) ? args.pop : {}
        destination = args.first || source.sub(/\.tt$/, '')

        source  = ::File.expand_path(@task.find_in_source_paths(source.to_s))
        context = instance_eval('binding')

        @task.create_file destination, nil, config do
          content = ERB.new(::File.binread(source), nil, '-', '@output_buffer').result(context)
          content = block.call(content) if block
          content
        end
      end

    end
  end
end