module Behavior

  module Placeable

    def self.included(klass)
      klass.extend ClassMethods
    end

    def drop
      return "It seems that the #{name} is cursed and cannot be dropped!" if self.is_cursed?
      previous_owner = self.user.current_nick
      self.place = Place.current
      self.user = nil if self.respond_to?(:user)
      self.is_hidden = false if self.respond_to?(:is_hidden)
      self.picked_up_at = nil if self.respond_to?(:picked_up_at)
      self.save
      Util::Randomizer.drop_message(name, previous_owner)
    end

    def hide
      return "Nice try, but the #{name} is cursed and cannot be hidden!" if self.is_cursed?
      self.place = nil
      self.user = nil if self.respond_to?(:user)
      self.is_hidden = true if self.respond_to?(:is_hidden)
      self.picked_up_at = nil if self.respond_to?(:picked_up_at)
      self.save
      Util::Randomizer.hide_message(name_with_article, owner_name)
    end

    def remove
      self.place = nil
      self.user = nil if self.respond_to?(:user)
      self.is_hidden = false if self.respond_to?(:is_hidden)
      self.picked_up_at = nil if self.respond_to?(:picked_up_at)
      self.save
    end

    def is_present?
      Alice::Place.current.contains?(self)
    end

    module ClassMethods

      def claimed
        excludes(user_id: nil)
      end

      def hidden
        excludes(place_id: nil)
      end

      def reset_hidden!
        hidden.map{|obj| obj.update_attribute(place: nil) }
      end

      def unclaimed
        where(user_id: nil)
      end

      def unplaced
        where(place_id: nil)
      end

    end

  end

end
