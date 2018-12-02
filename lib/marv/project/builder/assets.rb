require 'sprockets'
require 'autoprefixer-rails'

module Marv
  module Project
    class Assets

      # Initialize assets builder
      def initialize(builder)
        @builder = builder
        @task = builder.task
        @project = builder.project
        @config = builder.project.config

        init_sprockets
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
              @task.copy_file filename, ::File.join(@project.build_path, 'images', ::File.basename(filename)), :force => true
            end
          end
        end
      end

      # Build assets
      def build_assets
        @project.assets.each do |asset|
          # Catch any sprockets errors and continue the process
          begin
            build_asset_file asset
          rescue Exception => e
            print_asset_error asset, e.message
          end
        end
      end

      # Build asset file
      def build_asset_file(asset)
        destination = ::File.join(@project.build_path, asset)

        @task.shell.mute do
          sprocket = @sprockets.find_asset(asset.last)
          # Create asset destination
          @task.empty_directory ::File.dirname(destination) unless ::File.directory?(::File.dirname(destination))
          # Write file to destination
          sprocket.write_to(destination) unless sprocket.nil?
        end
      end

      # Print error to screen and file
      def print_asset_error(asset, message)
        destination = ::File.join(@project.build_path, asset)

        @task.say_error "Error while building #{asset.last}:", message

        @task.shell.mute do
          @task.create_file destination unless ::File.exists?(destination)
          @task.append_to_file destination, message
        end
      end

      # Init sprockets
      def init_sprockets
        @sprockets   = ::Sprockets::Environment.new
        autoprefixer = @config[:autoprefixer]

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

        unless autoprefixer == false
          AutoprefixerRails.install(@sprockets, Hash(autoprefixer))
        end
      end

    end
  end
end
