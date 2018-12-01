module Marv
  module CLI
    class Base < Thor

      # Include action helpers
      include Thor::Actions

      # Set layouts root path
      def self.source_root
        ::File.expand_path(::File.join(Marv.root, 'layouts'))
      end

      no_commands do
        # Print an empty message
        def say_empty
          self.say('')
        end

        # Print general message
        def say_message(text, color=nil, space_below=true, space_above=false)
          self.say_empty if space_above
          self.say(text, color)
          self.say_empty if space_below
        end

        # Print error message
        def say_error(text, message=nil, space_below=true, space_above=false)
          say_message(text, :red, false, space_above)
          say_message(message, nil, space_below, false) unless message.nil?
        end

        # Print info message
        def say_info(text, space_below=false, space_above=false)
          say_message(text, :cyan, space_below, space_above)
        end

        # Print warning message
        def say_warning(text, space_below=true, space_above=false)
          say_message(text, :yellow, space_below, space_above)
        end

        # Print success message
        def say_success(text, space_below=true, space_above=false)
          say_message(text, :green, space_below, space_above)
        end
      end

    end
  end
end
