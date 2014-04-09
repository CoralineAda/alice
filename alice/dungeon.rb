class Alice::Dungeon

  def self.reset!
    Alice::Actor.reset_hidden!
    Alice::Beverage.reset_hidden!
    Alice::Item.reset_hidden!
    Alice::Place.delete_all
    Alice::Place.generate!(is_current: true)
  end

end