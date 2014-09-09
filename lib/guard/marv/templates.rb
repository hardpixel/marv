require 'guard'
require 'guard/guard'

module Guard
  class MarvTemplates < ::Guard::Guard

    def initialize(watchers=[], options={})
      super
    end

    # Runs on marv watch
    def start
      UI.info "Copying templates over"
      copy_templates
    end

    # Runs on all command in guard console
    def run_all
      UI.info "Rebuilding all templates"
      copy_templates(true)
    end

    # Called on file(s) modifications
    def run_on_change(paths)
      UI.info "Templates have changed, copying over"
      copy_templates(true)
    end

    def copy_templates(clean=nil)
      unless clean.nil?
        ::Marv::Guard.builder.clean_templates
      end
      ::Marv::Guard.builder.copy_templates
    end

  end
end
