require 'guard'
require 'guard/guard'

module Guard
  class Templates < ::Guard::Guard

    def initialize(watchers=[], options={})
      @builder = Marv::Project::Guard.builder
      super
    end

    # Runs on marv watch
    def start
      UI.info "Copying templates over"
      @builder.run_templates
    end

    # Runs on all command in guard console
    def run_all
      UI.info "Rebuilding all templates"
      @builder.run_templates(true)
    end

    # Called on file(s) modifications
    def run_on_change(paths)
      UI.info "Templates have changed, copying over"
      @builder.run_templates
    end

  end
end
