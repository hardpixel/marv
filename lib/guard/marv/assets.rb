require 'guard'
require 'guard/guard'

module Guard
  class MarvAssets < ::Guard::Guard

    def initialize(watchers=[], options={})
      super
    end

    def start
      UI.info "Building all assets"
      build_assets
    end

    # Called on Ctrl-\ signal
    # This method should be principally used for long action like running all specs/tests/...
    def run_all
      UI.info "Rebuilding all assets"
      clean_build_assets
    end

    # Called on file(s) modifications
    def run_on_change(paths)
      UI.info "Assets have changed, rebuilding..."
      clean_build_assets
    end

    def build_assets
      ::Marv::Guard.builder.build_assets
    end

    def clean_build_assets
      ::Marv::Guard.builder.clean_images
      ::Marv::Guard.builder.build_assets
    end

  end
end
