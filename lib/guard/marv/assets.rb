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
      @builder.build_assets
      @builder.copy_images
    end

    # Runs on all command in guard console
    def run_all
      UI.info "Rebuilding all assets"
      @builder.build_assets
      @builder.clean_images
      @builder.copy_images
    end

    # Called on file(s) modifications
    def run_on_change(paths)
      UI.info "Assets have changed, rebuilding..."
      @builder.build_assets
      @builder.copy_images
    end

  end
end
