require 'guard'
require 'guard/guard'

module Guard
  class MarvConfig < ::Guard::Guard

    def initialize(watchers=[], options={})
      super
    end

    # This method should be mainly used for "reload"
    def reload
      UI.info "Reloading project config"
      ::Marv::Guard.project.load_config
    end

    # Runs on all command in guard console
    def run_all
      UI.info "Reloading project config"
      ::Marv::Guard.project.load_config
      true
    end

    # Called on file(s) modifications
    def run_on_change(paths)
      UI.info "Project config changed, reloading"
      ::Marv::Guard.project.load_config
      ::Marv::Guard.builder = ::Marv::Builder.new(::Marv::Guard.project)

      # Rebuild everything if the config changes
      ::Marv::Guard.builder.build
    end

  end
end
