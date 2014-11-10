require 'guard'
require 'guard/plugin'

module Guard
  class Config < ::Guard::Plugin

    def initialize(options={})
      @builder = Marv::Project::Guard.builder
      super
    end

    # This method should be mainly used for "reload"
    def reload
      UI.info "Reloading project config"
      @builder.build_project
    end

    # Runs on all command in guard console
    def run_all
      UI.info "Reloading project config"
      @builder.build_project
    end

    # Called on file(s) modifications
    def run_on_change(paths)
      UI.info "Project config changed, reloading"
      @builder.build_project
    end

  end
end
