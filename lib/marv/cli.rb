require 'thor'
require 'guard/marv/assets'
require 'guard/marv/config'
require 'guard/marv/templates'
require 'guard/marv/functions'
require 'guard/marv/folders'

module Marv
  class CLI < Thor

    include Thor::Actions

    def self.source_root
      File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'layouts'))
    end

    desc "create DIRECTORY", "Creates a Marv project into specified directory"
    long_desc "Creates a new project. Use the layout option to choose a scaffold"
    method_option :layout, :type => :string, :default => 'default', :desc => "Name of alternate layout"
    method_option :local, :type => :boolean, :force => false, :desc => "Use local layout from .marv folder"
    def create(dir)
      theme = {}
      theme[:name] = dir

      project = Marv::Project.create(dir, theme, self, options[:layout], options[:local])
    end

    desc "link SERVER or DIRECTORY", "Create a symbolic link to the compilation directory"
    long_desc "This command will symlink the compiled version of the project to the specified server or WordPress install path."+
    "If you don't provide a directory or a server name, the symlink will be created in Marv global themes or plugins folder."
    method_option :folder, :type => :string, :enum => %w{themes plugins}, :required => true, :desc => "Link Marv project in themes or plugins folfer"
    def link(dir='global')
      project = Marv::Project.new('.', self)

      unless File.directory?(project.build_path)
        FileUtils.mkdir_p project.build_path
      end

      if dir == 'global'
        link_project_globaly(options, project)
      else
        wp_path = File.join(dir, 'wp-content', options[:folder])
        server_path = File.join(ENV['HOME'], '.marv', 'servers', dir, 'wp-content', options[:folder])
        link_project(wp_path, server_path, project)
      end
    end

    desc "watch", "Start watch process"
    long_desc "Watches the source directory in your Marv project for changes, and reflects those changes in a compile folder"
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

    desc "package FILENAME", "Compile and zip your Marv project to FILENAME.zip"
    method_option :config, :type => :string, :desc => "Name of alternate config file"
    def package(filename=nil)
      project = Marv::Project.new('.', self, nil, options[:config])

      builder = Builder.new(project)
      builder.build
      builder.zip(filename)
    end

    desc "server SERVER", "Create a Marv server with the specified name"
    method_option :list, :type => :boolean, :force => false, :desc => "List all available Marv servers"
    method_option :start, :type => :boolean, :force => false, :desc => "Create a new Marv server"
    method_option :stop, :type => :boolean, :force => false, :desc => "Stop a running Marv server"
    method_option :restart, :type => :boolean, :force => false, :desc => "Restart a Marv server"
    # method_option :backup, :type => :boolean, :force => false, :desc => "Backup a Marv server"
    # method_option :restore, :type => :boolean, :force => false, :desc => "Restore a Marv server"
    method_option :remove, :type => :boolean, :force => false, :desc => "Remove a Marv server"
    def server(name=nil)
      if options.empty?
        server = Marv::Server.new(name, self, server_config)
        server.create_server
      end

      if options[:remove]
        server = Marv::Server.new(name, self, server_config(true, name))
        server.remove_server
      end

      if options[:start] or options[:stop] or options[:restart]
        server = Marv::Server.new(name, self, nil)
        control_server(options, name, server)
      end

      if options[:list]
        list_servers
      end
    end

    protected

    def link_project_globaly(options, project)
      project_folder = project.project_id.gsub('_', '-')
      global_folder = File.join(ENV['HOME'], '.marv', options[:folder])

      unless File.directory?(global_folder)
        FileUtils.mkdir_p global_folder
      end

      do_link(project, File.join(global_folder, project_folder))

      servers = Dir.glob(File.join(ENV['HOME'], '.marv', 'servers' , '*'))

      servers.each do |server|
        shell.mute { do_link(project, File.join(server, 'wp-content', options[:folder], project_folder)) }
      end
    end

    def server_config(remove=nil, name=nil)
      config = {}

      if remove.nil?
        say "This will create a new Marv server with WordPress installed:", :green
      else
        say "This will remove #{name} server:", :yellow
      end

      config[:user] = ask("Mysql username:", nil, {:default => "root"})
      config[:password] = ask("Mysql user password:", nil, {:default => "required"})
      config[:host] = ask("Mysql host:", nil, {:default => "localhost"})
      config[:port] = ask("Mysql port:", nil, {:default => "3306"})

      if remove.nil?
        config[:version] = ask("WordPress version:", nil, {:default => "latest"})
      end

      config
    end

    def control_server(options, name, server)
      if options[:start]
        server.start_server
      end

      if options[:stop]
        server.stop_server
      end

      if options[:restart]
        server.restart_server
      end
    end

    def list_servers
      servers_root = File.join(ENV['HOME'], '.marv', 'servers')
      servers = Dir.glob(File.join(servers_root, '*'))

      say "Available marv servers:"
      servers.each do |server|
        say '- ' + File.basename(server), :cyan
      end
    end

    def link_project( wp_path, server_path, project)
      project_folder = project.project_id.gsub('_', '-')

      if File.directory?(wp_path)
        do_link(project, File.join(wp_path, project_folder))
      else
        do_link(project, File.join(server_path, project_folder))
      end
    end

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
