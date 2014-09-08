require 'guard'
require 'guard/guard'

module Guard
  class MarvTemplates < ::Guard::Guard

    def initialize(watchers=[], options={})
      super
    end

    def start
      UI.info "Copying templates over"
      copy_templates
    end

    def run_all
      UI.info "Rebuilding all templates"
      clean_copy_templates
    end

    # Called on file(s) modifications
    def run_on_change(paths)
      UI.info "Templates have changed, copying over"
      clean_copy_templates
    end

    def copy_templates
      ::Marv::Guard.builder.copy_templates
    end

    def clean_copy_templates
      ::Marv::Guard.builder.clean_templates
      ::Marv::Guard.builder.copy_templates
    end

  end
end
