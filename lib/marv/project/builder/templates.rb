module Marv
  module Project
    class Templates

      # Initialize templates builder
      def initialize(builder)
        @builder = builder
        @task = builder.task
        @project = builder.project
        @config = builder.project.config
      end

      # Clean Templates
      def clean_templates
        @task.shell.mute do
          ::Dir.glob(::File.join(@project.build_path, '*.php')).each do |file|
            unless file.include?('functions.php') || file.include?(::File.basename(@project.plugin_file))
              @task.remove_file file
            end
          end
        end
      end

      # Copy templates
      def copy_templates
        @task.shell.mute do
          ::Dir.glob(::File.join(@project.templates_path, '**', '*')).each do |file|
            target = ::File.join(@project.build_path, ::File.basename(file))

            @task.copy_file file, target, :force => true unless ::File.directory?(file)
          end
        end
      end

    end
  end
end