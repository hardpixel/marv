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
      @builder.copy_templates
      @builder.copy_folders
    end

    # Runs on all command in guard console
    def run_all
      UI.info "Rebuilding all templates"
      @builder.clean_templates
      @builder.copy_templates
      @builder.clean_folders
      @builder.copy_folders
    end

    # Called on file(s) modifications
    def run_on_change(paths)
      UI.info "Templates have changed, copying over"
      @builder.copy_templates
      @builder.copy_folders
    end

  end
end
