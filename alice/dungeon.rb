class Alice::Dungeon

  def self.reset!
    cleanup
    Alice::Place.generate!(is_current: true)
    assign_fruitcake
    ensure_grue
    make_stuff
    true
  end

  def self.win!
    User.active_and_online.each{|actor| actor.score_point(5) }
    grue = Actor.grue
    grue.update_attribute(:points, [grue.points - 5, 0].max)
  end

  def self.lose!
    User.active_and_online.each{|actor| actor.update_attribute(:points, [actor.points - 5, 0].max) }
    grue = Actor.grue
    grue.update_attribute(:points, grue.points + 5)
  end

  def self.cleanup
    Actor.reset_all
    Alice::Item.reset_cursed
    Alice::Beverage.sweep
    Alice::Item.sweep
    Alice::Machine.sweep
    Alice::Item.weapons.map{|w| w.delete}
    Alice::Item.keys.map{|w| w.delete}
    Alice::Beverage.sweep
    Alice::Place.delete_all
  end

  def self.assign_fruitcake
    victim = User.active_and_online.sample
    victim && victim.items << Alice::Item.fruitcake
  end

  def self.ensure_grue
    Actor.grue || Actor.create(name: 'Grue', is_grue: true)
  end

  def self.however_many
    rand(10) + 2
  end

  def self.make_stuff
    Alice::Item.create(name: Alice::Util::Randomizer.game, is_game: true)
    however_many.times.each{ |name| Alice::Item.create(name: Alice::Util::Randomizer.item) }
    (however_many / 2).times.each{ |name| Alice::Item.create(name: Alice::Util::Randomizer.weapon, is_weapon: true) }
    however_many.times.each{ |name| Alice::Item.create(name: Alice::Util::Randomizer.reading_material, is_readable: true) }
    (however_many / 2).times.each{ |name| Alice::Item.create(name: Alice::Util::Randomizer.keys, is_key: true) }
  end

end