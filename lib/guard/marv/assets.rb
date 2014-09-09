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
      build_assets
    end

    # Runs on all command in guard console
    def run_all
      UI.info "Rebuilding all assets"
      build_assets(true)
    end

    # Called on file(s) modifications
    def run_on_change(paths)
      UI.info "Assets have changed, rebuilding..."
      build_assets(true)
    end

    # Build and clean assets
    def build_assets(clean=nil)
      unless clean.nil?
        ::Marv::Guard.builder.clean_images
      end
      ::Marv::Guard.builder.build_assets
    end

  end
end
