require 'thor'
require 'marv/cli'
require 'marv/global'

module Marv

  def self.root
    ::File.expand_path(::File.join(::File.dirname(__FILE__), '..'))
  end

end

trap 'SIGINT' do
  puts
  puts
  puts ::Time.now.strftime('%T') + ' - INFO - Bye bye...'
  exit 130
end
