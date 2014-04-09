module Alice

  module Behavior

    module Tradeable

      def self.included(klass)
        klass.extend ClassMethods
      end

      def drop
        self.place = Alice::Place.last
        self.user = nil
        self.picked_up_at = nil
        self.save
      end

      def hide(nick)
        self.place = Alice::Place.random
        self.user = nil
        self.is_hidden = true
        self.save
        hide_message(nick)
      end

      def owned_time
        return "" unless self.picked_up_at
        hours = (Time.now.minus_with_coercion(self.picked_up_at)/3600).round
        elapsed = hours < 1 && "a short while"
        elapsed ||= hours < 24 && "less than a day"
        elapsed ||= hours / 24 == 1 ? "one day" : "#{hours / 24} days"
        elapsed
      end

      def owner
        self.user.proper_name
      end

      def pass_to(actor)
        if recipient = Alice::User.find_or_create(actor)
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
    
      module ClassMethods
      
        def self.reset_hidden!
          hidden.map(&:delete)
        end

        def self.unclaimed
          where(user_id: nil, place_id: nil)
        end

        def self.hidden
          excludes(place_id: nil)
        end

        def self.claimed
          excludes(user_id: nil)
        end


      end

    end

  end

end
