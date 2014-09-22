require 'net/http'
require 'childprocess'

module Marv
  module Server
    class Actions

      # Initialize actions
      def initialize(server)
        @server = server
        @task = server.task
        @path = server.path
        @name = server.name
        @database = server.database
      end

      # Initialize server start
      def start
        # Setup server
        server = TCPServer.new('127.0.0.1', 0)
        port = server.addr[1]
        server.close()

        # Run PHP server
        ::Dir.chdir @path
        @php = ChildProcess.build 'php', '-S', "#{@server.host}:#{@server.port}", 'router.php'
        @php.start

        # Write PHP proccess id to file
        @task.shell.mute do
          @task.create_file ::File.join(@path, 'php.pid'), @php.pid, :force => true
        end

        @task.say "Visit http://#{@server.host}:#{@server.port}", :green
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
          @database.query("DROP DATABASE IF EXISTS #{@server.db_name}")
          @database.query("REVOKE ALL PRIVILEGES ON #{@server.db_name}.* FROM '#{@server.db_user}'@'#{@server.db_host}'")
          @database.query("FLUSH PRIVILEGES")
          @database.close
        rescue Exception => e
          @task.say "Error while removing database:"
          @task.say e.message + "\n", :red
        end

        @task.shell.mute do
          stop
          @task.remove_dir @path
        end

        @task.say "Server successfully removed!", :green
      end

    end
  end
end