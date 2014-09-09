require 'guard'
require 'guard/guard'

module Guard
  class MarvFunctions < ::Guard::Guard

    def initialize(watchers=[], options={})
      super
    end

    # Runs on marv watch
    def start
      UI.info "Copying functions over"
      copy_functions
    end

    # Runs on all command in guard console
    def run_all
      UI.info "Rebuilding all functions"
      copy_functions(true)
    end

    # Called on file(s) modifications
    def run_on_change(paths)
      UI.info "Functions have changed, copying over"
      copy_functions(true)
    end

    # Copy and clean functions and includes folder
    def copy_functions(clean=nil)
      unless clean.nil?
        ::Marv::Guard.builder.clean_functions
        ::Marv::Guard.builder.clean_includes
      end
      ::Marv::Guard.builder.copy_functions
      ::Marv::Guard.builder.copy_includes
    end

  end
end
