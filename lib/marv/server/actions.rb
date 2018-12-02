require 'net/http'
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
      def start(from_command=true)
        if is_server_running?
          @task.say_warning "Server is already running.", false
          abort
        end

        unless is_port_available?(@server.host, @server.port)
          @task.say_warning "Port is not available!", false, true
          change_server_port
        end

        run_server(from_command)
      end

      # Initialize server stop
      def stop(message=true)
        abort_noexist
        pid_file = ::File.join(@path, 'php.pid')

        begin
          if ::File.exists?(pid_file)
            pid = ::File.read(pid_file).to_i

            ::Process.kill('KILL', pid)
            @task.say_warning("Server #{@name} stopped.", false) if message
          end
        rescue
          @task.say_warning("Server #{@name} is not running.", false) if message
        end
      end

      # Initialize server restart
      def restart
        stop(false)
        @task.say_info "Restarting server #{@name}...", true
        sleep 3
        start
      end

      # Remove server
      def remove
        abort_noexist
        @task.say_warning("This will remove server #{@name} and all data will be lost.")

        if @task.said_yes?("Are you sure you want to remove server?")
          begin
            @server.remove_database

            @task.shell.mute do
              stop(false)
              remove_hotel_server
              @task.remove_dir @path
            end
          rescue Exception => e
            @task.say_error "Error while removing server:", e.message
            abort
          end

          @task.say_success "Server successfully removed.", false, true
        end
      end

      # Run server
      def run_server(from_command=true)
        abort_noexist_cmd('php')
        ::Dir.chdir @path

        unless @debug
          @php = ChildProcess.build 'php', '-S', "#{@server.host}:#{@server.port}", 'router.php'
          @php.start

          # Write PHP proccess id to file
          @task.shell.mute do
            @task.create_file ::File.join(@path, 'php.pid'), @php.pid, :force => true
          end
        end

        @task.say_success "Server #{@server.name} is running.", false, !from_command
        @task.say_message "✔ http://#{@server.host}:#{@server.port}", false, false

        # Start server in debug mode
        if @debug
          system "php -S #{@server.host}:#{@server.port} router.php"
        end
      end

      # Abort if not exists
      def abort_noexist
        unless @server.exists?
          @task.say_error("Server #{@name} does not exist!")
          abort
        end
      end

      # Abort if command does no exist
      def abort_noexist_cmd(exec_name, text=nil)
        unless @task.exec_exixts?(exec_name)
          text ||= exec_name.upcase

          @task.say_error("#{text} is not installed on your system!")
          abort
        end
      end

      # Remove hotel server if it exists
      def remove_hotel_server
        if @task.exec_exixts?('hotel')
          begin
            `cd #{@path} && hotel rm`
          rescue ExceptionName
            return true
          end
        end
      end

      # Change server port
      def change_server_port
        @task.say_info "Use another port to run the server.", true
        port = @task.ask_input "Which port would you like to use?"

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

          if ::File.exists?(pid_file)
            pid = ::File.read(pid_file).to_i
            return ::Process.kill(0, pid) == 1
          end

          return false
        rescue
          return false
        end
      end

      # Check if port is available
      def is_port_available?(host=@server.host, port=@server.port)
        begin
          url = URI.parse("http://#{host}:#{port}/")
          req = Net::HTTP.new(url.host, url.port)
          req.request_head(url)

          return false
        rescue
          return true
        end
      end

    end
  end
end
