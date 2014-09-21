require 'sprockets'
require 'marv/engines'

module Marv
  module Project
    class Builder

      # Initialize project builder
      def initialize(project)
        @project = project
        @task = project.task
        @config = project.config

        init_sprockets
      end

      # Start builder
      def build_project
        clean_directory
        build_assets
        clean_images
        copy_images
        clean_templates
        copy_templates
        clean_functions
        copy_functions
        clean_includes
        copy_includes
        clean_folders
        copy_folders
      end

      # Build project to a directory
      def build_to(dir)
        build_project
        # Remove build directory
        @task.shell.mute do
          @task.remove_dir ::File.expand_path(dir)
        end
        # Copy files from .watch/build directory
        @task.directory @project.build_path, ::File.expand_path(dir)
      end

      # Clean build directory
      def clean_directory
        @task.shell.mute do
          @task.remove_dir @project.build_path
        end
      end

      # Clean Templates
      def clean_templates
        @task.shell.mute do
          ::Dir.glob(::File.join(@project.build_path, '*.php')).each do |file|
            unless file.include?('functions.php') || file.include?(::File.basename(@project.plugin_file))
              @task.remove_file file
            end
          end
        end
      end

      # Copy templates
      def copy_templates
        @task.shell.mute do
          ::Dir.glob(::File.join(@project.templates_path, '**', '*')).each do |file|
            target = ::File.join(@project.build_path, ::File.basename(file))

            @task.copy_file file, target, :force => true unless ::File.directory?(file)
          end
        end
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
          ::Dir.glob(::File.join(@project.functions_path, '*')).each do |file|
            if file == @project.functions_file || file == @project.plugin_file
              @task.copy_file file, ::File.join(@project.build_path, ::File.basename(file)), :force => true
            else
              @task.copy_file file, ::File.join(@project.build_path, 'functions', ::File.basename(file)), :force => true
            end
          end
        end
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

            @task.directory folder, target
          end
        end
      end

      # Clean images
      def clean_images
        @task.shell.mute do
          # Remove screenshot image
          ::Dir.glob(::File.join(@project.build_path, 'screenshot.*')).each do |file|
            @task.remove_file file
          end

          # Remove images folder
          @task.remove_dir ::File.join(@project.build_path, 'images')
        end
      end

      # Copy images
      def copy_images
        @task.shell.mute do
          ::Dir.glob(::File.join(@project.assets_path, 'images', '*')).each do |filename|
            # Check for screenshot and move it into main build directory
            if filename.index(/screenshot/)
              @task.copy_file filename, ::File.join(@project.build_path, ::File.basename(filename)), :force => true
            else
              # Copy the other files in images directory
              @task.copy_file filename, ::File.join(@project.build_path, 'images'), :force => true
            end
          end
        end
      end

      # Build assets
      def build_assets
        @task.shell.mute do
          @project.assets.each do |asset|
            destination = ::File.join(@project.build_path, asset)
            # Catch any sprockets errors and continue the process
            begin
              sprocket = @sprockets.find_asset(asset.last)
              # Create assets destination
              unless ::File.directory?(::File.dirname(destination))
                @task.empty_directory ::File.dirname(destination)
              end
              # Write file to destination
              sprocket.write_to(destination) unless sprocket.nil?
            rescue Exception => e
              @task.say "Error while building #{asset.last}:"
              @task.say e.message, :red

              # Print error to file
              @task.create_file destination unless ::File.exists?(destination)
              @task.append_to_file destination, e.message
            end
          end
        end
      end

      # Init sprockets
      def init_sprockets
        @sprockets = ::Sprockets::Environment.new

        ['javascripts', 'stylesheets'].each do |dir|
          @sprockets.append_path ::File.join(@project.assets_path, dir)
        end

        # Check for js compression
        if @config[:compress_js]
          @sprockets.js_compressor = :uglify
        end

        # Check for css compression
        if @config[:compress_css]
          @sprockets.css_compressor = :scss
        end

        # Passing the @project instance variable to the Sprockets::Context instance
        # used for processing the asset ERB files
        @sprockets.context_class.instance_exec(@project) do |project|
          define_method :config do
            project.config
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