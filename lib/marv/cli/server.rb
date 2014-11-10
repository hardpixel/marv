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
      def list
        servers = Marv::Global.new(self).servers

        say "Available marv servers:"
        servers.each do |server|
          say '- ' + server, :cyan
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
      def start(dir)
        servers_path = Marv::Global.new(self).servers_path

        if ::File.directory?(::File.join(servers_path, dir))
          server = Marv::Server::Server.new(self, dir)
          action = Marv::Server::Actions.new(server)
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
        server = Marv::Server::Server.new(self, dir)
        action = Marv::Server::Actions.new(server)
        action.stop
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