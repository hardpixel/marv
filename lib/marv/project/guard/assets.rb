module Guard
  class Assets < ::Guard::Plugin

    def initialize(options={})
      super
    end

    # Runs on marv watch
    def start
      build_all_assets "Building all assets"
    end

    # Runs on all command in guard console
    def run_all
      build_all_assets "Rebuilding all assets", true
    end

    # Called on file(s) modifications
    def run_on_change(paths)
      build_all_assets "Assets have changed, rebuilding..."
    end

    # Build all assets
    def build_all_assets(message, clean=nil)
      builder = Marv::Project::Guard.builder.assets

      UI.info message
      builder.clean_images unless clean.nil?
      builder.copy_images
      builder.build_assets
    end

  end
end
