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
        self.user && self.user.proper_name || self.actor && self.actor.proper_name || nil
      end

      def pass_to(actor)
        if recipient = Alice::Actor::where(name: actor) || Alice::User.find_or_create(actor)
          if recipient.is_bot?
            self.message = "#{recipient.proper_name} does not accept drinks."
          else
            self.message = "#{owner} passes the #{self.name} to #{recipient.proper_name}. Cheers!"
            self.user = recipient
            self.save
          end
        else
          self.message = "You can't share the #{self.name} with an imaginary friend."
        end
        self
      end

    end

  end

end