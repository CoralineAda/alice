module Alice

  module Behavior

    module Ownable

      def self.included(klass)
        klass.extend ClassMethods
      end

      def owned_time
        event = self.picked_up_at || self.created_at
        hours = (Time.now.minus_with_coercion(event)/3600).round
        elapsed = hours < 1 && "a short while"
        elapsed ||= hours < 24 && "less than a day"
        elapsed ||= hours / 24 == 1 ? "one day" : "#{hours / 24} days"
        elapsed
      end

      def owner
        self.user || self.actor && self.actor.proper_name || Actor.new(name: "Edwina Nobody")
      end

      def owner_name
        owner.proper_name
      end

      def transfer_to(recipient)
        return unless recipient
        original_owner = self.user
        self.user_id = recipient.id
        self.picked_up_at = DateTime.now
        self.save
        Alice::Util::Randomizer.give_message(original_owner.current_nick, recipient.current_nick, self.name_with_article)
      end

    end

  end

end