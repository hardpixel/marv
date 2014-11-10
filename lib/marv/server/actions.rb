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
      end

      # Initialize server start
      def start
        ::Dir.chdir @path
        @php = ChildProcess.build 'php', '-S', "#{@server.host}:#{@server.port}", 'router.php'
        @php.start

        # Write PHP proccess id to file
        @task.shell.mute do
          @task.create_file ::File.join(@path, 'php.pid'), @php.pid, :force => true
        end

        @task.say "Server #{@server.name} is running", :cyan
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

    end
  end
end