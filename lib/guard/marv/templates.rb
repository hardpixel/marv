require 'guard'
require 'guard/guard'

module Guard
  class MarvTemplates < ::Guard::Guard

    def initialize(watchers=[], options={})
      super
    end

    # Runs on marv watch
    def start
      copy_templates("Copying templates over", true)
    end

    # Runs on all command in guard console
    def run_all
      copy_templates("Rebuilding all templates", true)
    end

    # Called on file(s) modifications
    def run_on_change(paths)
      copy_templates("Templates have changed, copying over", nil)
    end

    # Copy templates
    def copy_templates(message, clean)
      UI.info message
      ::Marv::Guard.builder.copy_templates(clean)
    end

  end
end
