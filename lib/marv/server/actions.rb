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
        end

        # Initialize server start
        def start
          # Setup server
          server = TCPServer.new('127.0.0.1', 0)
          port = server.addr[1]
          server.close()

          # Run PHP server
          @task.shell.mute do
            ::Dir.chdir @path
            @php = ChildProcess.build 'php', '-S', "#{@server.host}:#{@server.port}", 'router.php'
            @php.start
            # Write PHP proccess id to file
            @task.create_file ::File.join(@path, 'php.pid'), @php.pid, :force => true
          end

          @task.say "Visit http://#{@server.host}:#{@server.port}", :green
        end

        # Initialize server stop
        def stop
          @task.shell.mute do
            pid_file = ::File.join(@path, 'php.pid')

            if File.exists?(pid_file)
              pid = ::File.read(pid_file).to_i

              ::Process.kill('KILL', pid)
              @task.say "Server #{@name} stopped", :yellow
              exit
            end

            @task.say "Server #{@name} is not running", :red
          end
        end

        # Initialize server restart
        def restart
          stop
          start
        end

    end
  end
end