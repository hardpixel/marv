require 'guard'
require 'guard/guard'

# Marv pry console actions
require 'guard/marv/assets'
require 'guard/marv/config'
require 'guard/marv/templates'
require 'guard/marv/functions'

module Marv
  module Project
    module Guard

      class << self
        attr_accessor :project, :task, :builder
      end

      # Start project watcher
      def self.start(project, builder)
        @project = project
        @task = project.task
        @builder = builder
        options = {}

        options_hash = ""
        options.each do |k,v|
          options_hash << ", :#{k} => '#{v}'"
        end

        assets_path = project.assets_path.gsub(/#{project.root}\//, '')
        source_path = project.source_path.gsub(/#{project.root}\//, '')
        config_file = project.config_file.gsub(/#{project.root}\//, '')

        guardfile_contents = %Q{
          guard 'config'#{options_hash} do
            watch("#{config_file}")
          end
          guard 'assets' do
            watch(%r{#{assets_path}/javascripts/*})
            watch(%r{#{assets_path}/stylesheets/*})
            watch(%r{#{assets_path}/images/*})
          end
          guard 'templates' do
            watch(%r{#{source_path}/templates/*})
            watch(%r{#{source_path}/partials/*})
          end
          guard 'functions' do
            watch(%r{#{source_path}/functions/*})
            watch(%r{#{source_path}/includes/*})
          end
        }

        # Enable livereload
        if options[:livereload]
          guardfile_contents << %Q{
            guard 'livereload' do
              watch(%r{#{source_path}/*})
            end
          }
        end

        # Start guard watching
        ::Guard.start({ :guardfile_contents => guardfile_contents }).join
      end

    end
  end
end
