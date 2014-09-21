module Marv
  module Project
    class Link

      # Initialize project linker
      def initialize(project, dir)
        @project = project
        @task = project.task
        @dir = dir
        @options = link_options
        @global = Marv::Global.new(project.task)

        create_link
      end

      # Ask for link details
      def link_options
        options = {}

        options[:folder] = @task.ask "Where do you want to link your project?", :limited_to => ["themes", "plugins"], :default => "themes"

        return options
      end

      # Link target
      def link_target
        target = ::File.join(@global.global_path, @options[:folder], ::File.basename(@project.root))

        unless @dir.nil?
          target = ::File.join(@global.servers_path, @dir, 'wp-content', @options[:folder], ::File.basename(@project.root))

          unless @global.servers.include?(@dir)
            target = ::File.join(@dir, 'wp-content', @options[:folder], ::File.basename(@project.root))
          end
        end

        return target
      end

      # Create project link
      def create_link
        @task.create_link link_target, @project.build_path
      end

    end
  end
end