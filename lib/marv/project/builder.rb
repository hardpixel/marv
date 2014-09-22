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

        @assets.build_assets
        @assets.clean_images
        @assets.copy_images

        @templates.clean_templates
        @templates.copy_templates

        @functions.clean_functions
        @functions.copy_functions
        @functions.clean_includes
        @functions.copy_includes
        @functions.clean_folders
        @functions.copy_folders
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

    end
  end
end