require 'guard'
require 'guard/guard'

module Guard
  class Functions < ::Guard::Guard

    def initialize(watchers=[], options={})
      super
    end

    # Runs on marv watch
    def start
      copy_all_functions "Copying functions over"
    end

    # Runs on all command in guard console
    def run_all
      copy_all_functions "Rebuilding all functions", true
    end

    # Called on file(s) modifications
    def run_on_change(paths)
      copy_all_functions "Functions have changed, copying over"
    end

    # Copy all functions
    def copy_all_functions(message, clean=nil)
      builder = Marv::Project::Guard.builder.functions

      UI.info message

      unless clean.nil?
        builder.clean_functions
        builder.clean_includes
        builder.clean_folders
      end

      builder.copy_functions
      builder.copy_includes
      builder.copy_folders
    end

  end
end
