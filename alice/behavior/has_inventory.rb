module Alice

  module Behavior

    module HasInventory

      def inventory
        message = inventory_of_items
        message << inventory_of_beverages
        message
      end

      def inventory_of_beverages
        Alice::Beverage.inventory_from(self.proper_name, self.beverages)
      end

      def inventory_of_items
        Alice::Item.inventory_from(self.proper_name, self.items)
      end

      def add_to_inventory(item)
        item.user = self
        item.place = nil
        item.is_hidden = false
        item.picked_up_at = DateTime.now
        item.save
      end

      def remove_from_inventory(item)
        item.drop
        item.save
      end

    end

  end

end
