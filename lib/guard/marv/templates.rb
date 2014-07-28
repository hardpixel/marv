require 'guard'
require 'guard/guard'

module Guard
  class MarvTemplates < ::Guard::Guard
    def initialize(watchers=[], options={})
      super
    end

    def start
      UI.info "Copying templates over"
      ::Marv::Guard.builder.copy_templates
    end

    def run_all
      UI.info "Rebuilding all templates"
      ::Marv::Guard.builder.clean_templates
      ::Marv::Guard.builder.copy_templates
    end

    # Called on file(s) modifications
    def run_on_change(paths)
      UI.info "Templates have changed, copying over"
      ::Marv::Guard.builder.clean_templates
      ::Marv::Guard.builder.copy_templates
    end
  end
end
