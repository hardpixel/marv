require 'marv/project/builder'
require 'marv/project/guard'
require 'marv/project/actions'
require 'marv/project/create'

module Marv
  module Project
    class Project

      attr_accessor :root, :config, :task, :assets, :context

      # Initialize project config
      def initialize(task, dir, options)
        @task = task
        @global = Marv::Global.new(task)
        @dir = ::File.expand_path(dir)
        @options = options
        @root = root_path
        @config_file = config_file
        @config = project_config
        @assets = project_assets
        @context = project_context
      end

      # Project id
      def project_id
        ::File.basename(@dir).gsub(/\W/, '_').downcase
      end

      # Project root path
      def root_path
        ::File.expand_path(@dir)
      end

      # Project source path
      def source_path
        ::File.join(root_path, 'source')
      end

      # Project build path
      def build_path
        ::File.join(root_path, '.watch', 'build')
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
        config = {}

        # Merge global config
        config.merge!(@global.config)

        if @options.nil?
          config.merge!(project_config_file)
        else
          optional_config_file
          config.merge!(@options)
        end

        return config
      end

      # Check for config.rb in project folder
      def project_config_file
        config_file = {}

        if ::File.exists?(@config_file)
          config_file = @global.load_ruby_config(@config_file)
        else
          @task.say_error "Could not find the config file!", "Are you sure you're in a marv project directory?", false
          abort
        end

        return config_file
      end

      # Check for config file in options
      def optional_config_file
        if ::File.exists?(@options.to_s)
          @options = @global.load_ruby_config(::File.expand_path(@options))
        end
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

        return assets
      end

      # Get project class context
      def project_context
        instance_eval('binding')
      end

    end
  end
end
