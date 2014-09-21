module Marv
  module Project
    class Link

      # Initialize project linker
      def initialize(project, dir)
        @project = project
        @task = project.task
        @dir = dir
        @options = link_options
      end

      # Ask for link details
      def link_options
        options = {}

        options[:folder] = @task.ask "What type of project do you want to link?", :limited_to => ["theme", "plugin"], :default => "theme"

        return options
      end

    end
  end
end