require 'thor'
require 'marv/cli/cli'

module Marv

  def self.root
    ::File.expand_path(::File.join(::File.dirname(__FILE__), '..'))
  end

end