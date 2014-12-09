class Place

  include Mongoid::Document

  field :description
  field :exits, type: Array, default: []
  field :is_current, type: Boolean
  field :x, type: Integer
  field :y, type: Integer
  field :is_dark, type: Boolean
  field :locked_exit
  field :view_from_afar
  field :last_visited, type: DateTime

  has_many :actors
  has_many :beverages
  has_many :items
  has_many :machines

  index({ x: 1, y: 1 },    { unique: true })
  index({ is_current: 1 }, { unique: false })

  after_create  :place_item
  after_create  :place_actor
  after_create  :place_wand
  before_create :ensure_description

  DIRECTIONS = ['north', 'south', 'east', 'west']
  PITCH_BLACK = "It is pitch black. You are likely to be eaten by a grue."

  def self.current
    where(:is_current => true).last || generate!(is_current: true)
  end

  def self.generate!(args={})
    x = args[:x] || 0
    y = args[:y] || 0
    description = PITCH_BLACK if x ==0 && y == 0
    room = create!(
      x: x,
      y: y,
      is_current: args[:is_current],
      description: description || random_description,
      is_dark: x == 0 && y == 0 || Alice::Util::Randomizer.one_chance_in(5)
    )
    if room.origin_square?
      room.exits = random_exits
    else
      room.exits = (random_exits | exits_for_neighbors).flatten.compact.uniq
    end
    room.save
    Util::Mapper.new.create
    room
  end

  def self.exits_for_neighbors
    DIRECTIONS.select do |direction|
      if neighbor = place_to(direction, false, false)
        neighbor.exits.to_a.include?(opposite_direction(direction))
      end
    end.reject(&:nil?)
  end

  def self.go(direction)
    return false unless current.exits.include?(direction.downcase)
    place_to(direction, true)
  end

  def self.place_to(direction, party_moving=false, create_place=true)
    if direction == 'north'
      y = current.y - 1
    elsif direction == 'south'
      y = current.y + 1
    else
      y = current.y
    end

    if direction == 'west'
      x = current.x - 1
    elsif direction == 'east'
      x = current.x + 1
    else
      x = current.x
    end

   room = Place.where(x: x, y: y).first
    if create_place
      room ||= Place.generate!(
        x: x,
        y:y,
        entered_from: opposite_direction(direction)
      )
    end
    return room.enter if room && party_moving
    return room
  end

  def self.opposite_direction(direction)
    return 'south' if direction == 'north'
    return 'north' if direction == 'south'
    return 'east' if direction == 'west'
    return 'west' if direction == 'east'
  end

  def self.random_description
    description = [
      Alice::Util::Randomizer.room_adjective,
      Alice::Util::Randomizer.room_type,
      Alice::Util::Randomizer.room_description
    ].join(' ') + "."
    description
  end

  def self.random_exits
    DIRECTIONS.sample(rand(2) + 2)
  end

  def self.set_current_room(room)
    Place.current.update_attribute(:is_current, false)
    room.update_attribute(:is_current, true)
  end

  def self.visited
    excludes(last_visited: nil)
  end

  def already_visited?
    self.last_visited.present?
  end

  def contains?(noun)
    noun.place == self
  end

  def contents
    return unless stuff.present? || has_actor?
    contents_text = ""
    contents_text << "You notice #{self.actors.map(&:name).to_sentence} #{Alice::Util::Randomizer.action}. " if self.has_actor?
    contents_text << "Contents: #{stuff.map(&:name).to_sentence}. " if stuff.present?
    contents_text
  end

  def coords
    [self.x, self.y]
  end

  def describe
    if self.origin_square?
      message = "#{self.description} #{contents} Exits: #{exits.to_a.to_sentence}. "
    elsif self.is_dark?
      message = PITCH_BLACK
    else
      message = "You are in #{self.description}. #{contents} Exits: #{exits.to_sentence}. "
    end
    if self.has_grue?
      message = handle_grue
    end
    message
  end

  def ensure_description
    return true if self.description.present? && self.view_from_afar.present?
    self.description ||= Place.random_description
    self.view_from_afar ||= Alice::Util::Randomizer.view_from_afar
  end

  def enter
    Place.set_current_room(self)
    self.update_attribute(:last_visited, DateTime.now)
    Mapper.new.create
    place_grue
    place_item
    handle_grue || describe
  end

  def exit_is_locked?(direction)
    self.locked_exit == direction
  end

  def handle_grue
    if self.actors.include? Actor.grue
      if user = User.fighting.sample
        message = "Huzzah! After a difficult fight and against all odds, #{user.current_nick} brandishes #{user.pronoun_possessive} #{user.items.weapons.sample.name} and slays the grue! "
        message << Dungeon.win!
      else
        message = "Eep! After wandering around in the dark room for a moment, the party has been eaten by a grue! "
        message << Dungeon.lose!
      end
    end
  end

  def has_exit?(direction)
    self.exits.include?(direction)
  end

  def has_item?
    return true if self.items.present?
  end

  def has_actor?
    self.actors.present?
  end

  def has_grue?
    self.actors.grue.present?
  end

  def has_locked_door?
    return false if self.exits.count == 1
    return true if self.locked_exit.present?
    candidates = self.exits - neighbors.select{|n| ! n[:room].already_visited? }.map{|n| n[:direction]}
    if Alice::Util::Randomizer.one_chance_in(2)
      self.update_attribute(:locked_exit, candidates.sample)
      if room = neighbors.select{|n| n[:direction] == self.locked_exit}.first
        room[:room].lock_door(Place.opposite_direction(locked_exit))
      end
    end
  end

  def illuminate
    update_attributes(is_dark: false)
  end

  def lights_out
    update_attributes(is_dark: true)
  end

  def lock_door(direction)
    self.exits ||= (random_exits | ['direction']).flatten.compact.uniq
    self.locked_exit = direction
    self.save
  end

  def neighbors
    Place.where(x: ((self.x - 1)..(self.x + 1)), y: ((self.y - 1)..(self.y + 1))).reject{|p| p == self}
  end

  def origin_square?
    self.x == 0 && self.y == 0
  end

  def place_grue
    return false if self.origin_square?
    return true if has_grue?
    odds = self.is_dark? ? 7 : 20
    if Alice::Util::Randomizer.one_chance_in(odds) && actor = Actor.unplaced.grue
      actor.update_attribute(:place_id, self.id)
    end
  end

  def place_wand
    return false if self.origin_square?
    if Alice::Util::Randomizer.one_chance_in(10) && wand = Wand.unplaced.unclaimed.sample
      wand.update_attribute(:place_id, self.id)
    end
  end

  def place_item
    return false if self.origin_square? || Item.all.empty?
    if Alice::Util::Randomizer.one_chance_in(5)
      item = Item.hidden.sample || Item.unplaced.unclaimed.sample
      item.update_attribute(:place_id, self.id)
    end
  end

  def place_actor
    return false if self.origin_square?
    if Alice::Util::Randomizer.one_chance_in(10) && actor = Actor.in_play.unplaced.sample
      actor.update_attribute(:place_id, self.id)
    end
  end

  def stuff
    @stuff ||= self.items + self.beverages + self.machines
  end

  def unlock
    neighbors.select{|n| n[:direction] = self.locked_exit}.first[:room].update_attribute(:locked_exit, nil)
    self.update_attribute(:locked_exit, nil)
  end

  def view
    message = self.view_from_afar
    message << " There is someone in there but you can't make out who it is from here." if has_actor?
    message << " It is dark in there!" if has_grue? || is_dark?
    message
  end

end
