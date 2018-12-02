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
          @task.say_error "Project already exists", nil, false
          abort
        end

        @task.say_info "This will create a new project."
        @task.say_warning "Please enter project details below."

        # Get project options
        options = {}

        options[:name] = @task.ask_input "Enter project name:", :default => @global.config.fetch(:name, @dir)
        options[:uri] = @task.ask_input "Enter project URI:", :default => @global.config[:uri]
        options[:version] = @task.ask_input "Enter project version:", :default => @global.config.fetch(:version, '0.1.0')
        options[:description] = @task.ask_input "Enter project description:", :default => @global.config.fetch(:description, 'Created with Marv')

        options.merge!(ask_author_details)
        options.merge!(ask_project_layout)

        return options
      end

      # Ask author details
      def ask_author_details
        options = {}

        options[:author] = @task.ask_input "Enter project author:", :default => @global.config[:author]
        options[:author_uri] = @task.ask_input "Enter project author URI:", :default => @global.config[:author_uri]
        options[:license_name] = @task.ask_input "Enter project license name:", :default => @global.config[:license_name]
        options[:license_uri] = @task.ask_input "Enter project license URI:", :default => @global.config[:license_uri]

        return options
      end

      # Ask project layout
      def ask_project_layout
        options = {}

        if @global.layouts.empty?
          options.merge!(ask_builtin_project_layout)
        else
          if @task.said_yes?("Do you want to use a local layout?")
            options[:local_layout] = true
            options[:layout] = @task.ask_input "Which layout do you want to use?", :limited_to => @global.layouts
          else
            options.merge!(ask_builtin_project_layout)
          end
        end

        return options
      end

      # Ask builtin project layout
      def ask_builtin_project_layout
        options = {}

        options[:local_layout] = false
        options[:layout] = @task.ask_input "Which layout do you want to use?", :limited_to => ["theme", "plugin"], :default => "theme"

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
        @task.say_empty(2)

        create_project_dirs
        create_config_file
        parse_layout_files
      end

    end
  end
end
