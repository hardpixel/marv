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

        # Get project options
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
        config_rb = ::File.join(@path, 'config.rb')
        @task.template config_template, config_rb unless ::File.exists?(config_rb)
      end

      # Parse layout files in project dir
      def parse_layout_files
        project = Marv::Project::Project.new(@task, @path, nil)

        ::Dir.glob(::File.join(@layout, '**', '*')).each do |file|
          unless ::File.directory?(file)
            # Get source and target files
            source_file = file.gsub(@layout, '')
            target_file = ::File.join(@path, 'source', source_file)
            # Parse template file
            @global.template file, target_file, project.context
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
