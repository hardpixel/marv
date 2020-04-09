require 'guard/jobs/base'

module Guard
  module Jobs
    class PryWrapper < Base

      def _setup(options)
        Pry.config.should_load_rc = false
        Pry.config.should_load_local_rc = false
        history_file_path = options[:history_file] || HISTORY_FILE

        if legacy_pry?
          Pry.config.history.file = File.expand_path(history_file_path)
        else
          Pry.config.history_file = File.expand_path(history_file_path)
        end

        _add_hooks(options)

        ::Guard::Commands::All.import
        ::Guard::Commands::Change.import
        ::Guard::Commands::Notification.import
        ::Guard::Commands::Pause.import
        ::Guard::Commands::Reload.import
        ::Guard::Commands::Show.import
        ::Guard::Commands::Scope.import

        _setup_commands
        _configure_prompt
      end

      private

      attr_reader :thread

      def legacy_pry?
        Gem::Version.new(Pry::VERSION) < Gem::Version.new('0.13')
      end

      # Colorizes message using Thor Color Util
      #
      def _colorize(text, color)
        Marv.colorize(text, color)
      end

      # Configures the pry prompt to see `guard` instead of
      # `pry`.
      #
      def _configure_prompt
        prompt_procs = [
          _prompt(_colorize("\u00BB", :green)),
          _prompt(_colorize("*", :yellow))
        ]

        if legacy_pry?
          Pry.config.prompt = prompt_procs
        else
          prompt_args = [:marv, 'Marv prompt for guard watcher', prompt_procs]

          Pry::Prompt.add(*prompt_args) do |context, nesting, pry_instance, sep|
            sep.call(context, nesting, pry_instance)
          end

          Pry.config.prompt = Pry::Prompt[:marv]
        end
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
