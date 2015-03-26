require 'marv/server/server'

module Marv
  module CLI
    class Server < Thor

      def self.source_root
        ::File.expand_path(::File.join(Marv.root, 'layouts'))
      end

      include Thor::Actions

      # List all Marv servers
      desc "list", "List all Marv servers"
      def list(dir='all')
        servers = Marv::Global.new(self).servers

        if dir == 'all'
          say "Available marv servers:"
          servers.each_with_index do |server, index|
            say "#{index + 1}. #{server}", :cyan
          end

          if servers.empty?
            say "No servers found", :yellow
          end
        end

        if dir == 'running'
          index = 0
          say "Running marv servers:"
          servers.each do |dir|
            server = Marv::Server::Server.new(self, dir)
            action = Marv::Server::Actions.new(server)

            if action.is_server_running?
              say "#{index + 1}. #{server.name} [http://#{server.host}:#{server.port}]", :green
              index += 1
            end
          end

          if index == 0
            say "No running servers found", :yellow
          end
        end
      end

      # Create a new Marv server
      desc "create SERVER", "Create a Marv server with the specified name"
      def create(dir)
        server = Marv::Server::Server.new(self, dir)
        Marv::Server::Create.new(server)
      end

      # Start a Marv server
      desc "start SERVER", "Start the specified Marv server"
      method_option :debug, :type => :boolean, :desc => "Start server in debug mode"
      def start(dir)
        servers_path = Marv::Global.new(self).servers_path

        if ::File.directory?(::File.join(servers_path, dir))
          server = Marv::Server::Server.new(self, dir)
          action = Marv::Server::Actions.new(server, options[:debug])
          action.start
        end

        # Create server if it does not exist
        unless ::File.directory?(::File.join(servers_path, dir))
          say "Server #{dir} does not exist.", :yellow
          if yes?("Would you like to create the server?")
            create(dir)
          end
        end
      end

      # Start a Marv server
      desc "stop SERVER", "Stop the specified Marv server"
      def stop(dir)
        unless dir == 'all'
          server = Marv::Server::Server.new(self, dir)
          action = Marv::Server::Actions.new(server)
          action.stop
        end

        if dir == 'all'
          servers = Marv::Global.new(self).servers

          servers.each do |dir|
            server = Marv::Server::Server.new(self, dir)
            action = Marv::Server::Actions.new(server)

            if action.is_server_running?
              action.stop
            end
          end
        end
      end

      # Start a Marv server
      desc "restart SERVER", "Restart the specified Marv server"
      def restart(dir)
        server = Marv::Server::Server.new(self, dir)
        action = Marv::Server::Actions.new(server)
        action.restart
      end

      # Create a new Marv server
      desc "remove SERVER", "Remove the specified Marv server"
      def remove(dir)
        server = Marv::Server::Server.new(self, dir)
        action = Marv::Server::Actions.new(server)
        action.remove
      end

    end
  end
end