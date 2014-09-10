require 'guard'
require 'guard/guard'

module Guard
  class MarvFunctions < ::Guard::Guard

    def initialize(watchers=[], options={})
      super
    end

    # Runs on marv watch
    def start
      copy_functions("Copying functions over", true)
    end

    # Runs on all command in guard console
    def run_all
      copy_functions("Rebuilding all functions", true)
    end

    # Called on file(s) modifications
    def run_on_change(paths)
      copy_functions("Functions have changed, copying over", nil)
    end

    # Copy and clean functions and includes folder
    def copy_functions(message, clean)
      UI.info message
      ::Marv::Guard.builder.copy_functions(clean)
      ::Marv::Guard.builder.copy_includes(clean)
    end

  end
end
