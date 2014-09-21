require 'zip'

module Marv
  module Project
    class Package

      # Initialize project packager
      def initialize(project, builder, filename)
        @project = project
        @task = project.task
        @builder = builder
        @filename = filename

        create_package
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
        if @filename.nil?
          @filename = ::File.basename(@project.root)
        end
      end

      # Built to a temporary directory
      def build_to_temp_dir
        @builder.build_project

        # Copy build files to temporary directory
        @task.shell.mute do
          @task.directory @project.build_path, ::File.join(@project.package_path, @filename)
        end
      end

      # Create temporary package
      def create_temp_zip
        tmp_filename = ::File.join(@project.package_path, "#{@filename}.tmp")

        # Create an temporary file
        ::Zip.continue_on_exists_proc = true
        ::Zip::File.open(tmp_filename, Zip::File::CREATE) do |zip|
          # Get all filenames
          filenames = ::Dir.glob(::File.join(@project.package_path, @filename, '**', '*'))

          # Add each file in the zip file
          filenames.each do |filename|
            zip.add filename.gsub("#{@project.package_path}/", ''), filename
          end
        end
      end

      # Create the package
      def create_zip_file
        zip_filename = ::File.join(@project.package_path, "#{@filename}.zip")
        @task.copy_file ::File.join(@project.package_path, "#{@filename}.tmp"), zip_filename
      end

      # Remove temporary build directory
      def remove_temp_files
        @task.shell.mute do
          @task.remove_dir ::File.join(@project.package_path, @filename)
          @task.remove_file ::File.join(@project.package_path, "#{@filename}.tmp")
        end
      end

    end
  end
end