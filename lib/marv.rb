require 'thor'
require 'marv/cli'
require 'marv/global'

BANNER = <<-TEXT

  ::::    ::::      :::     :::::::::  :::     :::
  +:+:+: :+:+:+   :+: :+:   :+:    :+: :+:     :+:
  +:+ +:+:+ +:+  +:+   +:+  +:+    +:+ +:+     +:+
  +#+  +:+  +#+ +#++:++#++: +#++:++#:  +#+     +:+
  +#+       +#+ +#+     +#+ +#+    +#+  +#+   +#+
  #+#       #+# #+#     #+# #+#    #+#   #+#+#+#
  ###       ### ###     ### ###    ###     ###

TEXT

module Marv

  def self.root
    ::File.expand_path(::File.join(::File.dirname(__FILE__), '..'))
  end

  def self.banner_message
    puts BANNER
  end

  def self.exit_message
    time = ::Time.now.strftime('%T')
    puts  "\n\n#{time} - INFO - Bye bye..."
  end

  def self.colorize(text, color)
    @colorizer ||= Thor::Shell::Color.new
    @colorizer.set_color(text, color)
  end

end

trap 'SIGINT' do
  exit 130
end
