module Marv
  module CLI
    class Base < Thor

      # Include action helpers
      include Thor::Actions

      # Set layouts root path
      def self.source_root
        ::File.expand_path(::File.join(Marv.root, 'layouts'))
      end

      private

      # Print general message
      def say_message(text, color=nil, space=true)
        text = space ? "#{text}\n\n" : "#{text}\n"
        self.say(text, color)
      end

      # Print error message
      def say_error(text, space=true)
        say_message(text, :red, space)
      end

      # Print info message
      def say_info(text, space=true)
        say_message(text, :cyan, space)
      end

      # Print warning message
      def say_warning(text, space=false)
        say_message(text, :yellow, space)
      end

    end
  end
end
