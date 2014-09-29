require 'marv/cli/project'
require 'marv/cli/server'

module Marv
  module CLI
    class Commands < Project

      def self.source_root
        ::File.expand_path(::File.join(Marv.root, 'layouts'))
      end

      # Configure marv
      desc "config", "Configure Marv projects and servers"
      long_desc "Creates a global config.rb file that can be used to auto-configure your projects and servers"
      def config
        global = Marv::Global.new(self)
        global.reconfigure
      end

      desc "server [SUBCOMMAND]", "Manage marv servers (create, start and more...)"
      subcommand "server", Server

    end
  end
end