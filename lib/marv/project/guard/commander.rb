module Guard
  module Commander

    # Stop proccess
    def stop
      listener.stop
      interactor.background
      ::Guard::UI.debug "Guard stops all plugins"
      runner.run(:stop)
      ::Guard::Notifier.turn_off
    end

  end
end
