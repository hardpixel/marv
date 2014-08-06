require 'marv/error'

module Marv
  ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..'))
  autoload :Guard, 'marv/guard'
  autoload :CLI, 'marv/cli'
  autoload :Project, 'marv/project'
  autoload :Builder, 'marv/builder'
  autoload :Generator, 'marv/generator'
  autoload :Installer, 'marv/installer'
end