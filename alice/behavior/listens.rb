module Alice

  module Behavior

    module Listens

      def current_user_from(channel_user)
        Alice::User.find_or_create(chanel_user.user.nick)
      end

      def observer
        [Alice::Actor::Observer, Alice::User.bot].compact.sample
      end

    end

  end

end