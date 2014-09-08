require 'guard'
require 'guard/guard'

module Guard
  class MarvConfig < ::Guard::Guard

    def initialize(watchers=[], options={})
      super
    end

    # Called on Ctrl-Z signal
    # This method should be mainly used for "reload" (really!) actions like reloading passenger/spork/bundler/...
    def reload
      UI.info "Reloading project config"
      ::Marv::Guard.project.load_config
    end

    # Called on Ctrl-\ signal
    # This method should be principally used for long action like running all specs/tests/...
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
