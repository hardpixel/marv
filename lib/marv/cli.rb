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

    desc "create DIRECTORY", "Creates a Marv project into specified directory"
    long_desc "Creates a new project. Use the layout option to choose a scaffold"
    method_option :layout, :type => :string, :default => 'default', :desc => "Name of alternate layout"
    method_option :local, :type => :boolean, :force => false, :desc => "Use local layout from .marv folder"
    def create(dir)
      theme = {}
      theme[:name] = dir

      project = Marv::Project.create(dir, theme, self, options[:layout], options[:local])
    end

    desc "link SERVER", "Create a symbolic link to the compilation directory"
    long_desc "This command will symlink the compiled version of the project to the specified server or WordPress install path"
    method_option :folder, :type => :string, :aliases => "-f" , :enum => %w{themes plugins}, :required => true, :desc => "Link Marv project in themes or plugins folfer"
    method_option :global, :type => :boolean, :aliases => "-g" , :force => false, :desc => "Link Marv project in global folder"
    method_option :path, :type => :string, :aliases => "-p" , :desc => "Create a symbolic link to a WordPress folder"
    def link(server=nil)
      project = Marv::Project.new('.', self)
      project_folder = project.project_id.gsub('_', '-')

      FileUtils.mkdir_p project.build_path unless File.directory?(project.build_path)

      unless server.nil?
        server_path = File.join(ENV['HOME'], '.marv', 'servers', server, 'wp-content', options[:folder])

        unless options[:global]
          do_link(project, File.join(server_path, project_folder))
        end
      end

      if options[:global]
        global_folder = File.join(ENV['HOME'], '.marv', options[:folder])
        FileUtils.mkdir_p global_folder unless File.directory?(global_folder)

        do_link(project, File.join(global_folder, project_folder))

        servers = Dir.glob(File.join(ENV['HOME'], '.marv', 'servers' , '*'))

        servers.each do |server|
          shell.mute { do_link(project, File.join(server, 'wp-content', options[:folder], project_folder)) }
        end
      end

      if options[:path]
        wp_path = File.join(options[:path], 'wp-content', options[:folder])
        do_link(project, File.join(wp_path, project_folder))
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

    desc "server SERVER", "Start a Marv server by name"
    method_option :create, :type => :boolean, :aliases => "-c" , :force => false, :desc => "Create a new Marv server"
    method_option :stop, :type => :boolean, :aliases => "-s" , :force => false, :desc => "Stop a running Marv server"
    method_option :restart, :type => :boolean, :aliases => "-r" , :force => false, :desc => "Restart a Marv server"
    # method_option :backup, :type => :boolean, :force => false, :desc => "Backup a Marv server"
    # method_option :restore, :type => :boolean, :force => false, :desc => "Restore a Marv server"
    method_option :remove, :type => :boolean, :force => false, :desc => "Remove a Marv server"
    def server(name)
      config = {}

      if options[:create]
        say "This will create a new Marv server with WordPress installed:", :green
        config[:user] = ask("Mysql username:", nil, {:default => "root"})
        config[:password] = ask("Mysql user password:", nil, {:default => "required"})
        config[:host] = ask("Mysql host:", nil, {:default => "localhost"})
        config[:port] = ask("Mysql port:", nil, {:default => "3306"})
        config[:version] = ask("WordPress version:", nil, {:default => "latest"})

        server = Marv::Server.new(name, self, config)
        server.create_server
      else
        server = Marv::Server.new(name, self, nil)

        if options.empty?
          server.start_server
        end

        if options[:stop]
          server.stop_server
        end

        if options[:restart]
          server.restart_server
        end

        if options[:remove]
          say "This will remove the specified Marv server:", :green
          config[:user] = ask("Mysql username:", nil, {:default => "root"})
          config[:password] = ask("Mysql user password:", nil, {:default => "required"})
          config[:host] = ask("Mysql host:", nil, {:default => "localhost"})
          config[:port] = ask("Mysql port:", nil, {:default => "3306"})
          config[:version] = "latest"

          server = Marv::Server.new(name, self, config)
          server.remove_server
        end
      end
      exit
    end

    desc "servers OPTION", "List all available Marv servers"
    method_option :remove, :type => :boolean, :force => false, :desc => "Remove all Marv servers"
    # method_option :backup, :type => :boolean, :force => false, :desc => "Backup existing Marv servers"
    # method_option :restore, :type => :boolean, :force => false, :desc => "Restore Marv servers from backup file"
    def servers
      if options.empty?
        list_all_servers
      end

      if options[:remove]
        remove_all_servers
      end
      exit
    end

    protected

    def list_all_servers
      servers_root = File.join(ENV['HOME'], '.marv', 'servers')
      servers = Dir.glob(File.join(servers_root, '*'))

      servers.each do |server|
        say "Available marv servers:", :yellow
        say '- ' + File.basename(server), :green
      end
    end

    def remove_all_servers
      servers_root = File.join(ENV['HOME'], '.marv', 'servers')
      servers = Dir.glob(File.join(servers_root, '*'))

      servers.each do |server|
        server = Marv::Server.new(File.basename(server), self, nil)
        server.remove_server
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
