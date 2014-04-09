module Alice

  module Behavior

    module Tradeable

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
        
    end

  end

end
