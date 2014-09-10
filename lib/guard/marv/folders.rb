require 'guard'
require 'guard/guard'

module Guard
  class MarvFolders < ::Guard::Guard

    def initialize(watchers=[], options={})
      super
    end

    # Runs on marv watch
    def start
      UI.info "Copying folders over"
      ::Marv::Guard.builder.copy_folders
    end

    # Runs on all command in guard console
    def run_all
      UI.info "Rebuilding all folders"
      ::Marv::Guard.builder.copy_folders(true)
    end

    # Called on file(s) modifications
    def run_on_change(paths)
      UI.info "Folders have changed, copying over"
      ::Marv::Guard.builder.copy_folders(true)
    end

  end
end
