require 'guard'
require 'guard/guard'

module Guard
  class MarvFunctions < ::Guard::Guard
    def initialize(watchers=[], options={})
      super
    end

    def start
      UI.info "Copying functions over"
      ::Marv::Guard.builder.copy_functions
      ::Marv::Guard.builder.copy_includes
      ::Marv::Guard.builder.copy_extras
    end

    def run_all
      UI.info "Rebuilding all functions"
      ::Marv::Guard.builder.clean_functions
      ::Marv::Guard.builder.copy_functions
      ::Marv::Guard.builder.clean_includes
      ::Marv::Guard.builder.copy_includes
      ::Marv::Guard.builder.copy_extras
    end

    # Called on file(s) modifications
    def run_on_change(paths)
      UI.info "Functions have changed, copying over"
      ::Marv::Guard.builder.clean_functions
      ::Marv::Guard.builder.copy_functions
      ::Marv::Guard.builder.clean_includes
      ::Marv::Guard.builder.copy_includes
      ::Marv::Guard.builder.copy_extras
    end
  end
end
