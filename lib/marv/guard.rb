require 'guard'
require 'guard/guard'

module Marv
  module Guard

    class << self
      attr_accessor :project, :task, :builder
    end

    def self.add_guard(&block)
      @additional_guards ||= []
      @additional_guards << block
    end

    def self.start(project, task, options={}, livereload={})
      @project = project
      @task = task
      @builder = Builder.new(project)

      options_hash = ""
      options.each do |k,v|
        options_hash << ", :#{k} => '#{v}'"
      end

      assets_path = @project.assets_path.gsub(/#{@project.root}\//, '')
      source_path = @project.source_path.gsub(/#{@project.root}\//, '')
      config_file = @project.config_file.gsub(/#{@project.root}\//, '')

      guardfile_contents = %Q{
        guard 'marvconfig'#{options_hash} do
          watch("#{config_file}")
        end
        guard 'marvassets' do
          watch(%r{#{assets_path}/javascripts/*})
          watch(%r{#{assets_path}/stylesheets/*})
          watch(%r{#{assets_path}/images/*})
        end
        guard 'marvtemplates' do
          watch(%r{#{source_path}/templates/*})
          watch(%r{#{source_path}/partials/*})
        end
        guard 'marvfunctions' do
          watch(%r{#{source_path}/functions/*})
          watch(%r{#{source_path}/includes/*})
          watch(%r{#{source_path}/extras/*})
        end
      }

      if @project.config[:livereload]
        guardfile_contents << %Q{
          guard 'livereload' do
            watch(%r{#{source_path}/*})
          end
        }
      end

      (@additional_guards || []).each do |block|
        result = block.call(options, livereload)
        guardfile_contents << result unless result.nil?
      end
      ::Guard.start({ :guardfile_contents => guardfile_contents }).join
    end

  end
end
