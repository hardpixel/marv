require 'guard'
require 'guard/guard'

module Guard
  class Assets < ::Guard::Guard

    def initialize(watchers=[], options={})
      @builder = Marv::Project::Guard.builder
      super
    end

    # Runs on marv watch
    def start
      UI.info "Building all assets"
      @builder.run_assets
    end

    # Runs on all command in guard console
    def run_all
      UI.info "Rebuilding all assets"
      @builder.run_assets(true)
    end

    # Called on file(s) modifications
    def run_on_change(paths)
      UI.info "Assets have changed, rebuilding..."
      @builder.run_assets
    end

  end
end
