require 'cinch'

module Alice

  module Listeners

    class NumberWang

      include Alice::Behavior::Listens
      include Alice::Behavior::TracksActivity
      include Cinch::Plugin

      match /([0-9\,\.]+)$/, method: :check_number, use_prefix: false

      def check_number(channel_user, number)
        if Alice::Util::Randomizer.one_chance_in(5)
          current_user = current_user_from(channel_user)
          if Alice::Util::Randomizer.one_chance_in(5)
            3.times{current_user.score_point}
            message = "That's the Number Wang triple bonus! "
            message << "We like those decimals. " if number.include?('.')
            message << "The points go to #{channel_user}. "
          else
            current_user.score_point
            message = "That's Number Wang! "
            message << "We like those decimals. " if number.include?('.')
            message << "And the point goes to #{channel_user}. "
          end
          Alice::Util::Mediator.reply_to(channel_user, message)
        end
      end

    end

  end

end
