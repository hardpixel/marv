require 'marv/project/builder/engines'
require 'marv/project/builder/assets'
require 'marv/project/builder/functions'
require 'marv/project/builder/templates'

module Marv
  module Project
    class Builder

      attr_accessor :task, :project, :assets, :functions, :templates

      # Initialize project builder
      def initialize(project)
        @project = project
        @task = project.task
        @config = project.config
        @assets = Marv::Project::Assets.new(self)
        @functions = Marv::Project::Functions.new(self)
        @templates = Marv::Project::Templates.new(self)
      end

      # Start builder
      def build_project
        clean_directory

        @functions.copy_folders
        @templates.copy_templates

        @functions.copy_functions
        @functions.copy_includes

        @assets.copy_images
        @assets.build_assets
      end

      # Build project to a directory
      def build_to(dir)
        @task.say_warning "This will build project #{@project.project_id} in directory #{dir}."

        begin
          build_project
          # Remove build directory
          @task.shell.mute do
            @task.remove_dir ::File.expand_path(dir)
          end
          # Copy files from .watch/build directory
          @task.directory @project.build_path, ::File.expand_path(dir)
        rescue Exception => e
          @task.say_error "There was an error while building the project:", e.message, false
          abort
        end
      end

      # Clean build directory
      def clean_directory
        @task.shell.mute do
          @task.remove_dir @project.build_path
        end
      end

    end
  end
end
