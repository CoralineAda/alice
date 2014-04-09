module Alice

  module Behavior

    module TracksActivity

      def track(nick)
        Alice::User.find_or_create(nick).touch
      end

    end

  end

end