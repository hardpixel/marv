require 'guard'
require 'guard/plugin'

# Marv pry console actions
require 'marv/project/guard/assets'
require 'marv/project/guard/config'
require 'marv/project/guard/functions'
require 'marv/project/guard/templates'

module Marv
  module Project
    module Guard

      class << self
        attr_accessor :project, :task, :builder
      end

      # Add guard
      def self.add_guard(&block)
        @additional_guards ||= []
        @additional_guards << block
      end

      # Start project watcher
      def self.start(project, builder, options={}, livereload={})
        @project = project
        @task = project.task
        @builder = builder
        @options = project.config

        @options_hash = ""
        @options.each do |k,v|
          @options_hash << ", :#{k} => '#{v}'"
        end

        (@additional_guards || []).each do |block|
          result = block.call(@options, livereload)
          self.project_contents << result unless result.nil?
        end
        # Start guard watching
        ::Guard.start({ :guardfile_contents => self.project_contents }).join
      end

      # Guard contents
      def self.project_contents
        assets_path = @project.assets_path.gsub(/#{@project.root}\//, '')
        source_path = @project.source_path.gsub(/#{@project.root}\//, '')
        config_file = @project.config_file.gsub(/#{@project.root}\//, '')

        contents = %Q{
          guard 'config'#{@options_hash} do
            watch("#{config_file}")
          end
          guard 'functions' do
            watch(%r{#{source_path}/*})
          end
          guard 'templates' do
            watch(%r{#{source_path}/templates/*})
          end
          guard 'assets' do
            watch(%r{#{assets_path}/javascripts/*})
            watch(%r{#{assets_path}/stylesheets/*})
            watch(%r{#{assets_path}/images/*})
          end
        }

        # Enable livereload
        if @options[:livereload]
          contents << %Q{
            guard 'livereload' do
              watch(%r{#{source_path}/*})
            end
          }
        end

        return contents
      end

    end
  end
end
