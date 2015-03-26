require 'zip'

module Marv
  module Project
    class Actions

      # Initialize project actions
      def initialize(project, builder)
        @project = project
        @task = project.task
        @builder = builder
        @global = Marv::Global.new(project.task)
      end

      # Link project
      def link(dir)
        @link_dir = dir

        link_options
        link_target
        create_link
      end

      # Packgage project
      def package(filename)
        @package_name = filename

        create_package
      end

      # Ask for link details
      def link_options
        options = {}
        options[:folder] = @task.ask "Where do you want to link your project?", :limited_to => ["themes", "plugins"], :default => "themes"

        @link_options = options
      end

      # Link to server
      def link_to_server
        unless @link_dir.nil?
          path = ::File.join(@global.servers_path, @link_dir, 'wp-content', @link_options[:folder])

          if ::File.directory?(path)
            ::File.join(path, ::File.basename(@project.root))
          end
        end
      end

      # Link to wordpress
      def link_to_folder
        unless @link_dir.nil?
          if ::File.directory?(@link_dir)
            ::File.join(@link_dir, 'wp-content', @link_options[:folder], ::File.basename(@project.root))
          end
        end
      end

      # Link target
      def link_target
        target = link_to_server unless link_to_server.nil?
        target = link_to_folder unless link_to_folder.nil?

        if target.nil?
          @task.say "Destination server does not exist!", :red
          exit
        end

        @link_target = target
      end

      # Create project link
      def create_link
        unless ::File.directory?(@project.build_path)
          @task.shell.mute do
            @task.empty_directory @project.build_path
          end
        end

        @task.create_link @link_target, @project.build_path
      end

      # Create package
      def create_package
        create_package_dir
        set_package_filename
        build_to_temp_dir
        create_temp_zip
        create_zip_file
        remove_temp_files
      end

      # Create package directory
      def create_package_dir
        @task.shell.mute do
          unless ::File.directory?(@project.package_path)
            @task.empty_directory @project.package_path
          end
        end
      end

      # Set the package file name
      def set_package_filename
        if @package_name.nil?
          @package_name = ::File.basename(@project.root)
        end
      end

      # Built to a temporary directory
      def build_to_temp_dir
        @builder.build_project

        # Copy build files to temporary directory
        @task.shell.mute do
          @task.directory @project.build_path, ::File.join(@project.package_path, @package_name), :force => true
        end
      end

      # Create temporary package
      def create_temp_zip
        tmp_filename = ::File.join(@project.package_path, "#{@package_name}.tmp")

        # Create an temporary file
        ::Zip.continue_on_exists_proc = true
        ::Zip::File.open(tmp_filename, Zip::File::CREATE) do |zip|
          # Get all filenames
          filenames = ::Dir.glob(::File.join(@project.package_path, @package_name, '**', '*'))

          # Add each file in the zip file
          filenames.each do |filename|
            zip.add filename.gsub("#{@project.package_path}/", ''), filename
          end
        end
      end

      # Create the package
      def create_zip_file
        zip_filename = ::File.join(@project.package_path, "#{@package_name}.zip")
        @task.copy_file ::File.join(@project.package_path, "#{@package_name}.tmp"), zip_filename
      end

      # Remove temporary build directory
      def remove_temp_files
        @task.shell.mute do
          @task.remove_dir ::File.join(@project.package_path, @package_name)
          @task.remove_file ::File.join(@project.package_path, "#{@package_name}.tmp")
        end
      end

    end
  end
end
