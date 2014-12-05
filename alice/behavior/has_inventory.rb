module Alice

  module Behavior

    module HasInventory

      def inventory
        message = [inventory_of_items, inventory_of_wands, inventory_of_beverages]
        message.empty? ? "has no possessions." : message.compact.join(". ")
      end

      def inventory_of_beverages
        return if self.beverages.empty?
        Beverage.inventory_from(self, self.beverages)
      end

      def inventory_of_items
        return "" if self.items.empty?
        Item.inventory_from(self, self.items)
      end

      def inventory_of_wands
        return "" if self.wands.empty?
        Wand.inventory_from(self, self.wands)
      end

      def add_to_inventory(item)
        item.user = self
        item.place = nil
        item.is_hidden = false
        item.picked_up_at = DateTime.now
        item.save
      end

      def remove_from_inventory(item)
        return unless item
        item.drop
        item.save
      end

    end

  end

end
