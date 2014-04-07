class Alice::Place

  include Mongoid::Document

  field :description
  field :exits
  field :x, type: Integer
  field :y, type: Integer

  has_many :treasures
  
  DIRECTIONS = ['north', 'south', 'east', 'west']

  def self.last
    where(:was_last => true).last || all.sample || generate!
  end

  def self.go(direction)
    return false unless last.exits.include?(direction.downcase)
    move_to(direction)
  end

  def self.move_to(direction)
    if direction == 'north'
      y = last.y - 1
    elsif direction == 'south'
      y = last.y + 1
    else
      y = last.y
    end

    if direction == 'west'
      x = last.x - 1
    elsif direction == 'east'
      x = last.x + 1
    else
      x = last.x
    end

    room = Alice::Place.where(x: x, y: y).first
    room ||= Alice::Place.generate!(x: x, y:y, entered_from: opposite_direction(direction))
    set_last_room(room)
    last
  end

  def self.opposite_direction(direction)
    return 'south' if direction == 'north'
    return 'north' if direction == 'south'
    return 'east' if direction == 'west'
    return 'west' if direction == 'east'
  end

  def self.random
    room = all.sample || generate!
    set_last_room(room)
    room.description
  end

  def self.set_last_room(room)
    Alice::Place.last.update_attribute(:was_last, false)
    room.update_attribute(:was_last, true)
  end

  def self.generate!(args={})
    create(
      description: random_description,
      exits: (random_exits | [args[:entered_from]]).flatten.compact.uniq,
      treasures: [random_contents].compact,
      x: args[:x] || 0,
      y: args[:y] || 0,
    )
  end

  def self.random_contents
    return unless rand(10) == 1 
    Alice::Treasure.unclaimed.last
  end

  def self.random_description
    [adjective, type, description, '.'].join(' ').gsub('  ', ' ').gsub(' .', '.').gsub('..', '.')
  end

  def self.random_exits
    DIRECTIONS.sample(rand(2) + 2)
  end

  def self.adjective
    [
      "a dirty",
      "a dingy",
      "a sparse",
      "a spartan",
      "an echoing",
      "an incredibly dark",
      "an incredibly large",
      "a ridiculously small",
      "a colorfully decorated",
      "a richly decorated",
      "a sparsely decorated",
      "a desolate",
      "a low-ceilinged",
      "an immense",
      "a dark",
      "a sunny",
      "a large",
      "a long",
      "a high-ceilinged",
      "a brightly-lit",
      "a small",
      "a tiny",
      "a tidy",
      "an abandoned",
      "a filthy",
      "an immaculate",
      "a",
      "a",
      "a",
      "a",
      "a",
      "a",
      "a",
      "a",
    ].sample
  end

  def self.description
    [
      "with a locked door on the far wall",
      "with scratches along the floor",
      "with claw marks on the wall",
      "with bare shelves lining the walls",
      "with walls covered in paintings depicting #{things}",
      "covered with posters of #{things}",
      "with a portrait of #{Alice::User.random.primary_nick.capitalize} on the wall",
      "dominated by a large statue of #{Alice::User.random.primary_nick.capitalize}",
      "with graffiti spelling out #{Alice::User.random.primary_nick.capitalize}'s name on the wall",
      "with what appear to be footprints on the ceiling",
      "whose floor is covered in an inch of dust",
      "with a faint smell of gunpowder",
      "with a corpse in the middle of the room",
      "with a massive church organ against one wall",
      "containing #{things}",
      "housing #{things}",
      "containing #{things} and #{things}",
      "servng as a storage room for #{things}",
      "with walls papered in intricate yellow designs",
      "with crumbling walls",
      "with a drooping ceiling",
      "with broken furniture scattered throughout",
      "with #{things} on the floor",
      "with high shelves",
      "overrun with rats",
      "swarming with centipedes",
      "carpeted in deep red plush",
      "lit by candles",
      "lit by a large chandelier",
      "without any windows",
      "with tall windows",
      "shaped like a pentagon",
      "shaped like an octogon",
      "reminiscent of a hospital room",
      "with a hospital bed",
      "that is definitely not trapped",
      "that is home to a sleeping bear",
      "whose walls are discolored",
      "lit from an uknown source",
      "lined with bookshelves",
      "that stands empty",
      "with a window through which you can see #{things}",
      "partially in ruin",
      "echoing with hollow laughter",
      "with walls coated in flaking red paint",
      "with a strange insignia painted on the wall",
      "with a large chalk circle on the floor",
      "with a pentagram drawn in chalk on the floor",
      "littered with discarded papers",
      "littered with the remains of a hastily-consumed meal"
    ].sample
  end

  def self.things
    [
      "a flock of birds",
      "a stack of books",
      "a solitary table",
      "a deck of cards",
      "several broken dolls",
      "a creepy mannequin",
      "giant spiders",
      "miniature furniture",
      "a jewelry box",
      "a commemorative statuette of liberty",
      "an extensive DVD collection",
      "a towering wampus",
      "an old grandfather clock"
    ].sample
  end

  def self.type
    [
      "cavern",
      "cave",
      "cul-de-sac",
      "tunnel",
      "room",
      "chamber",
      "kitchen",
      "bathroom",
      "hallway",
      "great hall",
      "dining room",
      "auditorium",
      "dressing room",
      "theatre",
      "storeroom",
      "closet",
      "tardis",
      "bed chamber",
      "vault",
      "corridor",
      "lair",
      "pit"
    ].sample
  end

  def enter
    Alice::Place.set_last_room(self)
  end

  def describe
    "You are in #{self.description}. #{contents} Exits: #{exits.to_sentence}.".gsub('  ', ' ').gsub(' .', '.').gsub('..', '.')
  end

  def contents
    self.treasures.present? && self.treasures.to_sentence || ""
  end

end