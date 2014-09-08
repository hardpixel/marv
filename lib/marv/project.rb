require 'pathname'

module Marv
  class Project

    class << self
      def create(root, config, task, layout, local_layout)
        root = File.expand_path(root)

        project = self.new(root, task, config)
        Generator.run(project, layout, local_layout)

        project
      end
    end

    attr_accessor :root, :config, :task

    def initialize(root, task, config={}, config_file=nil)
      @root        = File.expand_path(root)
      @config      = config || {}
      @task        = task
      @config_file = config_file

      self.load_config if @config.empty?
    end

    def assets_path
      @assets_path ||= File.join(self.source_path, 'assets')
    end

    def build_path
      File.join(self.root, '.watch', 'build')
    end

    def source_path
      File.join(self.root, 'source')
    end

    def package_path
      File.join(self.root, 'package')
    end

    def templates_path
      File.join(self.source_path, 'templates')
    end

    def functions_path
      File.join(self.source_path, 'functions')
    end

    def includes_path
      File.join(self.source_path, 'includes')
    end

    def extras_path
      File.join(self.source_path, 'extras')
    end

    def config_file
      @config_file ||= File.join(self.root, 'config.rb')
    end

    def global_config_file
      @global_config_file ||= File.join(ENV['HOME'], '.marv', 'config.rb')
    end

    # Create a symlink from source to the project build dir
    def link(source)
      source = File.expand_path(source)

      unless File.writable?(File.dirname(source))
        @task.say "Permission Denied!", :red
        @task.say "You do not have write permissions for the destination folder"
        abort
      end

      unless File.directory?(File.dirname(source))
        raise Marv::LinkSourceDirNotFound
      end

      @task.link_file build_path, source
    end

    def project_id
      File.basename(self.root).gsub(/\W/, '_')
    end

    def load_config
      config = {}

      # Check for global (user) config.rb
      if File.exists?(self.global_config_file)
        config.merge!(load_ruby_config(self.global_config_file))
      end

      # Check for config.rb
      if File.exists?(self.config_file)
        config.merge!(load_ruby_config(self.config_file))
      else
        @task.say "Could not find the config file!", :red
        @task.say "Are you sure you're in a marv project directory?"
        abort
      end

      @config = config
    end

    def get_binding
      binding
    end

    def parse_erb(file)
      ERB.new(::File.binread(file), nil, '-', '@output_buffer').result(binding)
    end

    private

    def load_ruby_config(file)
      config = {}

      begin
        # Config file is just executed as straight ruby
        eval(File.read(file))
      rescue Exception => e
        @task.say "Error while evaluating config file:"
        @task.say e.message, :red
      end

      return config
    end

  end
end
