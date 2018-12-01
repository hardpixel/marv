require 'thor'
require 'marv/cli'
require 'marv/global'

module Marv

  def self.root
    ::File.expand_path(::File.join(::File.dirname(__FILE__), '..'))
  end

  def self.exit_message
    time = ::Time.now.strftime('%T')
    puts  "\n\n#{time} - INFO - Bye bye..."
  end

end

trap 'SIGINT' do
  exit 130
end
