module Alice

  module Behavior

    module Listens

      def current_user_from(channel_user)
        user = Alice::User.find_or_create(channel_user.user.nick)
        user.touch
        user
      end

      def observer
        [Alice::Actor.observer, Alice::User.bot].compact.sample
      end

    end

  end

end