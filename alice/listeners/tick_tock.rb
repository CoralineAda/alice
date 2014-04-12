require 'cinch'

module Alice

  module Listeners

    class TickTock

      include Alice::Behavior::Listens
      include Alice::Behavior::TracksActivity
      include Cinch::Plugin

      match /^\!test event/i, method: :trigger_event, use_prefix: false

      timer 60, method: :trigger_event

      def trigger_event(message=nil)
        
        Alice::Util::Mediator.send_raw(message)
      end

    end

  end

end
