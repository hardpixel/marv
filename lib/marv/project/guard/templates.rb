require 'guard'
require 'guard/guard'

module Guard
  class Templates < ::Guard::Guard

    def initialize(watchers=[], options={})
      super
    end

    # Runs on marv watch
    def start
      copy_all_templates "Copying templates over"
    end

    # Runs on all command in guard console
    def run_all
      copy_all_templates "Rebuilding all templates", true
    end

    # Called on file(s) modifications
    def run_on_change(paths)
      copy_all_templates "Templates have changed, copying over"
    end

    def copy_all_templates(message, clean=nil)
      builder = Marv::Project::Guard.builder.templates

      UI.info message
      builder.clean_templates unless clean.nil?
      builder.copy_templates
    end

  end
end
