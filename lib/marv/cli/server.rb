require 'marv/server/server'
require 'marv/server/create'
require 'marv/server/actions'
require 'marv/server/remove'
require 'marv/server/backup'
require 'marv/server/restore'

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
        Marv::Server::Actions.start(self, dir)
      end

      # Start a Marv server
      desc "stop SERVER", "Stop the specified Marv server"
      def stop(dir)
        Marv::Server::Actions.stop(self, dir)
      end

      # Start a Marv server
      desc "restart SERVER", "Restart the specified Marv server"
      def restart(dir)
        Marv::Server::Actions.restart(self, dir)
      end

      # Create a new Marv server
      desc "remove SERVER", "Remove the specified Marv server"
      def remove(dir)
        server = Marv::Server::Server.new(self, dir)
        Marv::Server::Remove.new(server)
      end

    end
  end
end