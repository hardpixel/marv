module Marv
  module Project
    class Create

      # Initialize project creator
      def initialize(task, dir)
        @task = task
        @dir = dir
        @path = project_path
        @global = Marv::Global.new(task)
        @options = project_options
        @layout = layout_path

        create_project
      end

      # Project path
      def project_path
        ::File.expand_path(@dir)
      end

      # Ask for project details
      def project_options
        # Check if project exists and abort
        if ::File.directory?(@path)
          @task.say "Project already exists", :red
          abort
        end

        @task.say "This will create a new project.", :cyan
        @task.say "Please enter project details below."

        # Get project options
        options = {}

        options[:name] = @task.ask "Enter project name", :default => @global.config[:name]
        options[:uri] = @task.ask "Enter project URI", :default => @global.config[:uri]
        options[:version] = @task.ask "Enter project version", :default => @global.config[:version]
        options[:description] = @task.ask "Enter project description", :default => @global.config[:description]

        options.merge!(ask_author_details)
        options.merge!(ask_project_layout)

        return options
      end

      # Ask author details
      def ask_author_details
        options = {}

        options[:author] = @task.ask "Enter project author", :default => @global.config[:author]
        options[:author_uri] = @task.ask "Enter project author URI", :default => @global.config[:author_uri]
        options[:license_name] = @task.ask "Enter project license name", :default => @global.config[:license_name]
        options[:license_uri] = @task.ask "Enter project license URI", :default => @global.config[:license_uri]

        return options
      end

      # Ask project layout
      def ask_project_layout
        options = {}

        if @task.yes?("Do you want to use a local layout?")
          options[:local_layout] = true
          options[:layout] = @task.ask "Which layout do you want to use?", :limited_to => @global.layouts
        else
          options[:local_layout] = false
          options[:layout] = @task.ask "Which layout do you want to use?", :limited_to => ["theme", "plugin"], :default => "theme"
        end

        return options
      end

      # Choosen layout path
      def layout_path
        layout = ::File.expand_path(::File.join(Marv.root, 'layouts', @options[:layout]))

        if @options[:local_layout]
          layout = ::File.join(@global.layouts_path, @options[:layout])
        end

        return layout
      end

      # Project config template
      def config_template
        ::File.expand_path(::File.join(Marv.root, 'layouts', 'config', 'project.rb'))
      end

      # Create project directories
      def create_project_dirs
        ::Dir.glob(::File.join(@layout, '**', '*')).each do |dir|
          if ::File.directory?(dir)
            # Get source and target files
            source_dir = dir.gsub(@layout, '')
            target_dir = ::File.join(@path, 'source', source_dir)

            @task.empty_directory target_dir unless ::File.directory?(target_dir)
          end
        end

        # Create .wacth dir
        @task.shell.mute do
          watch_dir = ::File.join(@path, '.watch', 'build')
          @task.empty_directory watch_dir unless ::File.directory?(watch_dir)
        end
      end

      # Create config file
      def create_config_file
        @project = Marv::Project::Project.new(@task, @path, @options)

        config_rb = ::File.join(@path, 'config.rb')
        @global.template config_template, config_rb, @project.context unless ::File.exists?(config_rb)
      end

      # Parse layout files in project dir
      def parse_layout_files
        ::Dir.glob(::File.join(@layout, '**', '*')).each do |file|
          unless ::File.directory?(file)
            # Get source and target files
            source_file = file.gsub(@layout, '')
            target_file = ::File.join(@path, 'source', source_file)
            # Parse template file
            @global.template file, target_file, @project.context
          end
        end
      end

      # Create a new project
      def create_project
        create_project_dirs
        create_config_file
        parse_layout_files
      end

    end
  end
end
