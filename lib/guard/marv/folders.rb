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
      copy_folders
    end

    # Runs on all command in guard console
    def run_all
      UI.info "Rebuilding all folders"
      copy_folders(true)
    end

    # Called on file(s) modifications
    def run_on_change(paths)
      UI.info "Folders have changed, copying over"
      copy_folders(true)
    end

    # Copy and clean user added folders in source root
    def copy_folders(clean=nil)
      unless clean.nil?
        ::Marv::Guard.builder.clean_folders
      end
      ::Marv::Guard.builder.copy_folders
    end

  end
end
