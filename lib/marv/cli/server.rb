require 'marv/cli/base'
require 'marv/server/server'

module Marv
  module CLI
    class Server < Base

      # List all Marv servers
      desc "list", "List all Marv servers"
      def list(dir='all')
        servers = Marv::Global.new(self).servers

        if dir == 'all'
          say_info "Available marv servers:", true
          servers.each_with_index do |server_dir, index|
            server = Marv::Server::Server.new(self, server_dir)
            say_message "#{index + 1}. #{server.name} [http://#{server.host}:#{server.port}]", false
          end

          if servers.empty?
            say_warning "No servers found", false
          end
        end

        if dir == 'running'
          index = 0
          say_success "Running marv servers:", true
          servers.each do |server_dir|
            server = Marv::Server::Server.new(self, server_dir)
            action = Marv::Server::Actions.new(server)

            if action.is_server_running?
              say_message "#{index + 1}. #{server.name} [http://#{server.host}:#{server.port}]", false
              index += 1
            end
          end

          if index == 0
            say_warning "No running servers found", false
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
          say_warning "Server #{dir} does not exist."
          if said_yes?("Would you like to create the server?")
            say_empty
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

          servers.each do |server_dir|
            server = Marv::Server::Server.new(self, server_dir)
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
