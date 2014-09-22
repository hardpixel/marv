require 'guard'
require 'guard/guard'

module Guard
  class Functions < ::Guard::Guard

    def initialize(watchers=[], options={})
      @builder = Marv::Project::Guard.builder
      super
    end

    # Runs on marv watch
    def start
      UI.info "Copying functions over"
      @builder.run_functions
    end

    # Runs on all command in guard console
    def run_all
      UI.info "Rebuilding all functions"
      @builder.run_functions(true)
    end

    # Called on file(s) modifications
    def run_on_change(paths)
      UI.info "Functions have changed, copying over"
      @builder.run_functions
    end

  end
end
