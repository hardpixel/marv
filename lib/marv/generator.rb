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

    def copy_assets
      ['stylesheets', 'javascripts', 'images'].each do |folder|
        source = File.expand_path(File.join(self.layout_path, folder))
        target = File.expand_path(File.join(@project.assets_path, folder))

        render_directory(source, target)
      end

      self
    end

    def copy_folders
      ['templates', 'includes'].each do |folder|
        source = File.expand_path(File.join(self.layout_path, folder))
        target = File.expand_path(File.join(@project.source_path, folder))

        render_directory(source, target)
      end

      self
    end

    def copy_functions
      ['functions.php', @project.project_php_file].each do |file|
        source = File.expand_path(File.join(self.layout_path, 'functions', "#{file}.erb"))
        if File.exist?(source)
          target = File.expand_path(File.join(@project.source_path, 'functions', file))
          write_template(source, target)
        end
      end
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
      copy_assets
      copy_folders
      copy_functions

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
