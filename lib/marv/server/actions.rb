require 'socket'
require 'childprocess'

module Marv
  module Server
    class Actions

      # Initialize actions
      def initialize(server, debug=false)
        @server = server
        @task = server.task
        @path = server.path
        @name = server.name
        @debug = debug
      end

      # Initialize server start
      def start
        if is_server_running?
          @task.say "Server is already running", :yellow
          exit
        end

        unless is_port_available?
          @task.say "Port is not available!", :yellow
          change_server_port
        end

        run_server
      end

      # Initialize server stop
      def stop
        pid_file = ::File.join(@path, 'php.pid')

        begin
          if File.exists?(pid_file)
            pid = ::File.read(pid_file).to_i

            ::Process.kill('KILL', pid)
            @task.say "Server #{@name} stopped", :yellow
          end
        rescue Exception => e
          @task.say "Server #{@name} is not running", :yellow
        end
      end

      # Initialize server restart
      def restart
        stop
        start
      end

      # Remove server
      def remove
        begin
          @server.remove_database

          @task.shell.mute do
            stop
            @task.remove_dir @path
          end
        rescue Exception => e
          @task.say "Error while removing server:"
          @task.say e.message + "\n", :red
          exit
        end

        @task.say "Server successfully removed", :green
      end

      # Run server
      def run_server
        unless @debug
          ::Dir.chdir @path
          @php = ChildProcess.build 'php', '-S', "#{@server.host}:#{@server.port}", 'router.php'
          @php.start

          # Write PHP proccess id to file
          @task.shell.mute do
            @task.create_file ::File.join(@path, 'php.pid'), @php.pid, :force => true
          end
        end

        @task.say "Server #{@server.name} is running", :cyan
        @task.say "Visit http://#{@server.host}:#{@server.port}", :green

        # Start server in debug mode
        if @debug
          system "php -S #{@server.host}:#{@server.port} router.php"
        end
      end

      # Change server port
      def change_server_port
        @task.say "Use another port to run the server", :cyan
        port = @task.ask "Which port would you like to use?"

        # Check if port available
        if is_port_available?(@server.host, port)
          # Write port to server config
          @task.shell.mute do
            @task.gsub_file @server.config_file, "#{@server.port}", "#{port}"
          end

          @server.port = port
        else
          change_server_port
        end
      end

      # Check if port is available
      def is_server_running?(server=@server)
        begin
          pid_file = ::File.join(server.path, 'php.pid')
          pid = ::File.read(pid_file).to_i

          ::Process.kill(0, pid)
        rescue Exception => e
          return false
        end

        return true
      end

      # Check if port is available
      def is_port_available?(host=@server.host, port=@server.port)
        begin
          ::TCPServer.new(host, port)
        rescue Exception => e
          return false
        end

        return true
      end

    end
  end
end
