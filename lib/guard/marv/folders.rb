require 'guard'
require 'guard/guard'

module Guard
  class MarvFolders < ::Guard::Guard

    def initialize(watchers=[], options={})
      super
    end

    # Runs on marv watch
    def start
      copy_folders("Copying folders over")
    end

    # Runs on all command in guard console
    def run_all
      copy_folders("Rebuilding all folders", true)
    end

    # Called on file(s) modifications
    def run_on_change(paths)
      copy_folders("Folders have changed, copying over", true)
    end

    # Copy folders
    def copy_folders(message, clean)
      UI.info message
      ::Marv::Guard.builder.copy_folders(clean)
    end

  end
end
