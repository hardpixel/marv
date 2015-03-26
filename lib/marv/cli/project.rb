require 'marv/project/project'

module Marv
  module CLI
    class Project < Thor

      def self.source_root
        ::File.expand_path(::File.join(Marv.root, 'layouts'))
      end

      include Thor::Actions

      # Create a new Marv project
      desc "create DIRECTORY", "Creates a Marv project into specified directory"
      long_desc "Creates a new project. Use the layout option to choose a scaffold"
      def create(dir)
        Marv::Project::Create.new(self, dir)
      end

      # Link an existing project to a Marv server or an existing WordPress installation
      desc "link SERVER or DIRECTORY", "Create a symbolic link to the compilation directory"
      long_desc "This command will symlink the compiled version of the project to the specified server or WordPress install path."+
      "If you don't provide a directory or a server name, the symlink will be created in Marv global themes or plugins folder."
      def link(dir=nil)
        project = Marv::Project::Project.new(self, '.', nil)
        actions = Marv::Project::Actions.new(project, nil)
        actions.link(dir)
      end

      # Watch a Marv project for changes
      desc "watch", "Start watch process"
      long_desc "Watches the source directory in your Marv project for changes, and reflects those changes in a compile folder"
      method_option :config, :type => :string, :desc => "Name of alternate config file"
      def watch
        project = Marv::Project::Project.new(self, '.', options[:config])
        builder = Marv::Project::Builder.new(project)
        Marv::Project::Guard.start(project, builder)
      end

      # Build a Marv project to a directory
      desc "build DIRECTORY", "Build your theme into specified directory"
      method_option :config, :type => :string, :desc => "Name of alternate config file"
      def build(dir='build')
        project = Marv::Project::Project.new(self, '.', options[:config])
        builder = Marv::Project::Builder.new(project)
        builder.build_to(dir)
      end

      # Package a Marv project in a .zip file
      desc "package FILENAME", "Compile and zip your Marv project to FILENAME.zip"
      method_option :config, :type => :string, :desc => "Name of alternate config file"
      def package(filename=nil)
        project = Marv::Project::Project.new(self, '.', options[:config])
        builder = Marv::Project::Builder.new(project)
        actions = Marv::Project::Actions.new(project, builder)
        actions.package(filename)
      end

    end
  end
end