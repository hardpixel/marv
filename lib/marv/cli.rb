require 'thor'
require 'guard/marv/assets'
require 'guard/marv/config'
require 'guard/marv/templates'
require 'guard/marv/functions'

module Marv
  class CLI < Thor
    include Thor::Actions

    def self.source_root
      File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'layouts'))
    end

    desc "install DIRECTORY", "Creates a WordPress installation to run the project"
    long_desc "Creates a Wordpress installation to run the project. After setting up WordPress link your theme and start developing."
    method_option :wordpress, :type => :string, :default => 'latest', :desc => "WordPress version to install"
    def install(dir)
      installer = Marv::Installer.new(dir, options[:wordpress])
    end

    desc "create DIRECTORY", "Creates a Marv project"
    long_desc "Creates a new project. Use the layout option to choose a scaffold"
    method_option :layout, :type => :string, :default => 'default', :desc => "Name of alternate layout"
    def create(dir)
      theme = {}
      theme[:name] = dir

      project = Marv::Project.create(dir, theme, self, options[:layout])
    end

    desc "link PATH", "Create a symbolic link to the compilation directory"
    long_desc "This command will symlink the compiled version of the theme to the specified path.\n\n"+
      "To compile the theme use the `marv watch` command"
    def link(path)
      project = Marv::Project.new('.', self)

      FileUtils.mkdir_p project.build_path unless File.directory?(project.build_path)

      do_link(project, path)
    end

    desc "watch", "Start watch process"
    long_desc "Watches the source directory in your project for changes, and reflects those changes in a compile folder"
    method_option :config, :type => :string, :desc => "Name of alternate config file"
    def watch
      project = Marv::Project.new('.', self, nil, options[:config])

      # Empty the build directory before starting up to clean out old files
      FileUtils.rm_rf project.build_path
      FileUtils.mkdir_p project.build_path

      Marv::Guard.start(project, self)
    end

    desc "build DIRECTORY", "Build your theme into specified directory"
    method_option :config, :type => :string, :desc => "Name of alternate config file"
    def build(dir='build')
      project = Marv::Project.new('.', self, nil, options[:config])

      builder = Builder.new(project)
      builder.build

      Dir.glob(File.join(dir, '**', '*')).each do |file|
        shell.mute { remove_file(file) }
      end

      directory(project.build_path, dir)
    end

    desc "package FILENAME", "Compile and zip your project to FILENAME.zip"
    method_option :config, :type => :string, :desc => "Name of alternate config file"
    def package(filename=nil)
      project = Marv::Project.new('.', self, nil, options[:config])

      builder = Builder.new(project)
      builder.build
      builder.zip(filename)
    end

    protected

    def do_link(project, path)
      begin
        project.link(path)
      rescue LinkSourceDirNotFound
        say_status :error, "The path #{File.dirname(path)} does not exist", :red
        exit 2
      rescue Errno::EEXIST
        say_status :error, "The path #{path} already exists", :red
        exit 2
      end
    end
  end
end
