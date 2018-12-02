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
        def say_message(text, space_below=true, space_above=false, color=nil)
          self.say_empty if space_above
          self.say("#{text}", color)
          self.say_empty if space_below
        end

        # Print error message
        def say_error(text, message=nil, space_below=true, space_above=false)
          say_message(text, false, space_above, :red)
          say_message(message, space_below, false) unless message.nil?
        end

        # Print info message
        def say_info(text, space_below=false, space_above=false)
          say_message(text, space_below, space_above, :cyan)
        end

        # Print warning message
        def say_warning(text, space_below=true, space_above=false)
          say_message(text, space_below, space_above, :yellow)
        end

        # Print success message
        def say_success(text, space_below=true, space_above=false)
          say_message(text, space_below, space_above, :green)
        end

        # Ask for user input
        def ask_input(text, color=nil, *args)
          self.ask("#{text}", color, *args)
        end

        # Ask for option value
        def ask_option(text, color=nil, *args)
          self.ask("  #{text}", color, *args)
        end

        # Ask to change options
        def said_change?(text, *args)
          self.yes?("» #{text}", :cyan, *args)
        end

        # Ask for yes answer
        def said_yes?(text, *args)
          self.yes?("#{text}", :cyan, *args)
        end

        # Ask for no answer
        def said_no?(text, *args)
          self.no?("#{text}", :yellow, *args)
        end
      end

    end
  end
end
