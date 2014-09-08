require 'guard'
require 'guard/guard'

module Guard
  class MarvFolders < ::Guard::Guard

    def initialize(watchers=[], options={})
      super
    end

    def start
      UI.info "Copying folders over"
      copy_folders
    end

    def run_all
      UI.info "Rebuilding all folders"
      clean_copy_folders
    end

    # Called on file(s) modifications
    def run_on_change(paths)
      UI.info "Folders have changed, copying over"
      clean_copy_folders
    end

    def copy_folders
      ::Marv::Guard.builder.copy_folders
    end

    def clean_copy_folders
      ::Marv::Guard.builder.clean_folders
      ::Marv::Guard.builder.copy_folders
    end

  end
end
