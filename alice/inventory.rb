class Inventory

  def self.for(message)
    message.sender.inventory
  end

end
