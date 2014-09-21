module Marv
  module Project
    class Package

      # Initialize project packager
      def initialize(project, filename)
        @project = project
        @task = project.task
        @filename = filename
      end

    end
  end
end