# config.ru for Rackup + Wordpress

require 'rack-legacy'

module Rack
  module Legacy
    # patch Php from rack-legacy to write pid file and customize server
    class Php
      def initialize app, public_dir=Dir.getwd, php_exe='php', quiet=true
        @app = app; @public_dir = public_dir
        server = TCPServer.new('127.0.0.1', 0)
        port = server.addr[1]
        server.close()
        @proxy = Rack::ReverseProxy.new do
        reverse_proxy_options preserve_host: false
        reverse_proxy /^.*$/, "http://localhost:#{port}"
        end
        @php = ChildProcess.build php_exe,
        '-S', "localhost:#{port}", '-t', public_dir
        @php.io.inherit! unless quiet
        @php.start
        at_exit {@php.stop if @php.alive?}

        # Write PHP proccess id to file
        ::File.open(::File.join(@public_dir, 'php.pid'), 'w') do |file|
          file.write(@php.pid)
        end

        puts "Visit http://localhost:#{port}";
      end
    end
  end
end

use Rack::Legacy::Index
use Rack::Legacy::Php
use Rack::Legacy::Cgi
run Rack::File.new Dir.getwd
