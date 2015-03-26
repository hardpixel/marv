gem 'tilt', '!= 1.3.0', '~> 1.1'

require 'tilt'

module Tilt
  class SprocketsLessTemplate < LessTemplate

    class << self
      attr_accessor :load_path
    end

    def prepare
      parser = ::Less::Parser.new(:filename => eval_file, :line => line, :paths => [self.class.load_path])
      @engine = parser.parse(data)
    end

  end
end
