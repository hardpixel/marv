module Marv
  module Project
    class Functions

      # Initialize functions builder
      def initialize(builder)
        @builder = builder
        @task = builder.task
        @project = builder.project
        @config = builder.project.config
      end

      # Clean functions
      def clean_functions
        @task.shell.mute do
          #remove functions and plugin php
          @task.remove_file ::File.join(@project.build_path, ::File.basename(@project.functions_file))
          @task.remove_file ::File.join(@project.build_path, ::File.basename(@project.plugin_file))

          # Remove functions folder
          @task.remove_dir ::File.join(@project.build_path, 'functions')
        end
      end

      # Copy functions
      def copy_functions
        @task.shell.mute do
          files = copy_functions_files

          ::Dir.glob(::File.join(@project.functions_path, '*')).each do |file|
            unless files.include?(file)
              @task.copy_file file, ::File.join(@project.build_path, 'functions', ::File.basename(file)), :force => true
            end
          end
        end
      end

      # Copy functions
      def copy_functions_files
        files = [@project.functions_file, @project.plugin_file]

        ::Dir.glob(::File.join(@project.functions_path, '*')).each do |file|
          if files.include?(file)
            @task.copy_file file, ::File.join(@project.build_path, ::File.basename(file)), :force => true
          end
        end

        return files
      end

      # Clean includes
      def clean_includes
        @task.shell.mute do
          @task.remove_dir ::File.join(@project.build_path, 'includes')
        end
      end

      # Copy includes
      def copy_includes
        @task.shell.mute do
          ::Dir.glob(::File.join(@project.includes_path, '**', '*')).each do |file|
            source = file.gsub(@project.source_path, '')
            target = ::File.join(@project.build_path, source)

            @task.copy_file file, target, :force => true unless ::File.directory?(file)
          end
        end
      end

      # Clean folders
      def clean_folders
        @task.shell.mute do
          # Clean extra folder from project root
          extra_folders.each do |folder|
            source = folder.gsub(@project.source_path, '')
            target = ::File.join(@project.build_path, source)

            @task.remove_dir target
          end
        end
      end

      # Copy folders
      def copy_folders
        @task.shell.mute do
          # Copy extra folders to project root
          extra_folders.each do |folder|
            source = folder.gsub(@project.source_path, '')
            target = ::File.join(@project.build_path, source)

            @task.directory folder, target, :force => true
          end
        end
      end

      # Extra folders
      def extra_folders
        default = ['assets', 'functions', 'includes', 'templates']
        folders = []
        # Remove marv folders from root path
        ::Dir.glob(::File.join(@project.source_path, '*')).each do |folder|
          if ::File.directory?(folder) and ! default.include?(::File.basename(folder))
            folders << folder
          end
        end
        # Return folders array
        return folders
      end

    end
  end
end