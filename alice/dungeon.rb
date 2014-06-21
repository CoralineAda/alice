class Alice::Dungeon

  def self.reset!
    Actor.reset_all
    Alice::Item.reset_cursed
    Alice::Beverage.sweep
    Alice::Item.sweep
    Alice::Machine.sweep
    Alice::Place.delete_all
    Alice::Place.generate!(is_current: true)
    Item.create_defaults
    Item.deliver_fruitcake
    Actor::ensure_grue
    true
  end

  def self.win!
    User.award_points_to_active(5)
    Actor.grue.penalize(5)
  end

  def self.lose!
    User.award_points_to_active(-5)
    Actor.grue.score_points(5)
  end

end