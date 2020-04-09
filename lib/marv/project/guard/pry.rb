module Guard
  module Jobs
    class PryWrapper < Base

      private

      attr_reader :thread

      # Colorizes message using Thor Color Util
      #
      def _colorize(text, color)
        Marv.colorize(text, color)
      end

      # Configures the pry prompt to see `guard` instead of
      # `pry`.
      #
      def _configure_prompt
        Pry.config.prompt = [_prompt(_colorize("\u00BB", :green)), _prompt(_colorize("*", :yellow))]
      end

      # Returns a proc that will return itself a string ending with the given
      # `ending_char` when called.
      #
      def _prompt(ending_char)
        proc do |target_self, nest_level, pry|
          history    = pry.input_ring.size
          process    = ::Guard.listener.paused? ? _colorize("pause", :yellow) : _colorize("marv", :green)
          level      = ":#{nest_level}" unless nest_level.zero?
          hist_text  = _colorize("[#{history}]", :yellow)
          clip_text  = _colorize("(#{_clip_name(target_self)})", :cyan)
          level_text = _colorize("#{level}", :cyan)
          path_text  = _colorize(File.basename(Dir.pwd), :magenta)

          "#{hist_text} #{_scope_for_prompt}#{process} #{path_text} #{clip_text}#{level_text} #{ending_char} "
        end
      end

    end
  end
end
