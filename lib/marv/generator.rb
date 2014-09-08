module Marv
  class Generator

    class << self
      def run(project, layout, local_layout)
        generator = self.new(project, layout, local_layout)
        generator.run
      end
    end

    def initialize(project, layout, local_layout)
      @project = project
      @task    = project.task
      @layout  = layout
      @local   = local_layout
    end

    def create_structure
      # Create the build directory for Marv output
      @task.empty_directory @project.build_path

      source_paths = [
        ['assets', 'images'],
        ['assets', 'javascripts'],
        ['assets', 'stylesheets'],

        ['functions'],
        ['includes'],

        ['templates', 'pages'],
        ['templates', 'partials'],
      ]

      # Build out Marv structure in the source directory
      source_paths.each do |path|
        @task.empty_directory File.join(@project.source_path, path)
      end

      self
    end

    def copy_stylesheets
      source = File.expand_path(File.join(self.layout_path, 'stylesheets'))
      target = File.expand_path(File.join(@project.assets_path, 'stylesheets'))

      render_directory(source, target)

      self
    end

    def copy_javascript
      source = File.expand_path(File.join(self.layout_path, 'javascripts'))
      target = File.expand_path(File.join(@project.assets_path, 'javascripts'))

      render_directory(source, target)

      self
    end

    def copy_images
      source = File.expand_path(File.join(self.layout_path, 'images'))
      target = File.expand_path(File.join(@project.assets_path, 'images'))

      render_directory(source, target)

      self
    end

    def copy_templates
      source = File.expand_path(File.join(self.layout_path, 'templates'))
      target = File.expand_path(File.join(@project.source_path, 'templates'))

      render_directory(source, target)

      self
    end

    def copy_functions
      source = File.expand_path(File.join(self.layout_path, 'functions', 'functions.php.erb'))
      target = File.expand_path(File.join(@project.source_path, 'functions', 'functions.php'))

      write_template(source, target)
    end

    def copy_includes
      source = File.expand_path(File.join(self.layout_path, 'includes'))
      target = File.expand_path(File.join(@project.source_path, 'includes'))

      render_directory(source, target)

      self
    end

    def layout_path
      if @local
        @layout_path ||= File.join(ENV['HOME'], '.marv', 'layouts', @layout)
      else
        @layout_path ||= File.join(Marv::ROOT, 'layouts', @layout)
      end
    end

    def run
      write_config
      create_structure
      copy_stylesheets
      copy_javascript
      copy_images
      copy_templates
      copy_functions
      copy_includes

      return self
    end

    def write_config
      unless File.exists?(@project.global_config_file)
        @task.shell.mute do
          @task.create_file(@project.global_config_file) do
            "# Place your global configuration values here\n# config[:livereload] = true"
          end
        end
      end

      write_template(['config', 'project-config.rb'], @project.config_file)

      self
    end

    def write_template(source, target)
      source   = File.join(source)
      template = File.expand_path(@task.find_in_source_paths((source)))
      target   = File.expand_path(File.join(target))

      @task.create_file target do
        @project.parse_erb(template)
      end
    end

    protected

    def render_directory(source, target)
      Dir.glob("#{source}/**/*") do |file|
        unless File.directory?(file)
          source_file = file.gsub(source, '')
          target_file = File.join(target, source_file)

          if source_file.end_with? ".erb"
            target_file = target_file.slice(0..-5)

            content = @project.parse_erb(file)
          else
            content = File.open(file).read
          end

          @task.create_file target_file do
            content
          end
        end
      end
    end

  end
end
