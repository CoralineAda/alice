class Alice::Dungeon

  def self.reset!
    cleanup
    Alice::Place.generate!(is_current: true)
    assign_fruitcake
    make_stuff
    populate
    true
  end

  def self.cleanup
    Alice::Actor.delete_all
    Alice::Beverage.sweep
    Alice::Item.sweep
    Alice::Item.weapons.map{|w| w.delete}
    Alice::Beverage.sweep
    Alice::Place.delete_all
  end

  def self.assign_fruitcake
    victim = Alice::User.active_and_online.sample
    victim && victim.items << Alice::Item.fruitcake
  end

  def self.populate
    rand(10).times.each{ |name| Alice::Actor.create(name: Alice::Util::Randomizer.specific_person) }
  end

  def self.make_stuff
    rand(10).times.each{ |name| Alice::Item.create(name: Alice::Util::Randomizer.item) }
    rand(10).times.each{ |name| Alice::Item.create(name: Alice::Util::Randomizer.weapon, is_weapon: true) }
    rand(10).times.each{ |name| Alice::Item.create(name: Alice::Util::Randomizer.reading_material, is_readable: true) }
  end

end