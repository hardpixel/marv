require 'guard'
require 'guard/guard'

module Guard
  class MarvAssets < ::Guard::Guard

    def initialize(watchers=[], options={})
      super
    end

    # Runs on marv watch
    def start
      build_assets("Building all assets", true)
    end

    # Runs on all command in guard console
    def run_all
      build_assets("Rebuilding all assets", true)
    end

    # Called on file(s) modifications
    def run_on_change(paths)
      build_assets("Assets have changed, rebuilding...", nil)
    end

    # Build assets
    def build_assets(message, clean)
      UI.info message
      ::Marv::Guard.builder.build_assets(clean)
    end

  end
end
