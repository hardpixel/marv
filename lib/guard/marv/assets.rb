require 'guard'
require 'guard/guard'

module Guard
  class MarvAssets < ::Guard::Guard

    def initialize(watchers=[], options={})
      super
    end

    # Runs on marv watch
    def start
      UI.info "Building all assets"
      ::Marv::Guard.builder.build_assets
    end

    # Runs on all command in guard console
    def run_all
      UI.info "Rebuilding all assets"
      ::Marv::Guard.builder.build_assets(true)
    end

    # Called on file(s) modifications
    def run_on_change(paths)
      UI.info "Assets have changed, rebuilding..."
      ::Marv::Guard.builder.build_assets(true)
    end

  end
end
