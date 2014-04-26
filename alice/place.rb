class Alice::Place

  include Mongoid::Document

  field :description
  field :exits
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
  before_create :ensure_description

  DIRECTIONS = ['north', 'south', 'east', 'west']

  def self.current
    where(:is_current => true).last || all.sample || generate!
  end

  def self.generate!(args={})
    x = args[:x] || 0
    y = args[:y] || 0
    room = create(
      exits: (random_exits | [args[:entered_from]]).flatten.compact.uniq,
      x: x,
      y: y,
      is_current: args[:is_current],
      is_dark: x == 0 && y == 0 || Alice::Util::Randomizer.one_chance_in(5)
    )
    room.update_attribute(:description, random_description(room))
    room
  end

  def self.go(direction)
    return false unless current.exits.include?(direction.downcase)
    place_to(direction, true)
  end

  def self.place_to(direction, party_moving=false)
    if direction == 'north'
      y = current.y + 1
    elsif direction == 'south'
      y = current.y - 1
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

    room = Alice::Place.where(x: x, y: y).first
    room ||= Alice::Place.generate!(x: x, y:y, entered_from: opposite_direction(direction))
    return room.enter if party_moving
    return room
  end

  def self.opposite_direction(direction)
    return 'south' if direction == 'north'
    return 'north' if direction == 'south'
    return 'east' if direction == 'west'
    return 'west' if direction == 'east'
  end

  def self.random_description(room)
    return "It is pitch black. You are likely to be eaten by a grue" if room.origin_square?
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
    Alice::Place.current.update_attribute(:is_current, false)
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
      message = "#{self.description}. #{contents} Exits: #{exits.to_sentence}. "
    elsif self.is_dark?
      message = "It is pitch black and you can't see a thing. What if there is a grue?"
    else
      message = "You are in #{self.description}. #{contents} Exits: #{exits.to_sentence}. "
    end
    if self.has_grue?
      message << handle_grue
    end
    message
  end

  def ensure_description
    return true if self.description.present? && self.view_from_afar.present?
    self.description ||= Alice::Place.random_description(self)
    self.view_from_afar ||= Alice::Util::Randomizer.view_from_afar
  end

  def enter
    Alice::Place.set_current_room(self)
    self.update_attribute(:last_visited, DateTime.now)
    place_grue
    place_item
    handle_grue || describe
  end

  def exit_is_locked?(direction)
    self.locked_exit == direction
  end

  def handle_grue
    if self.actors.include? Alice::Actor.grue
      if user = Alice::User.fighting.sample
        Alice::Dungeon.win!
        "Huzzah! After a difficult fight and against all odds, #{user.proper_name} brandishes their #{user.weapons.sample.name} and slays the grue!"
      else
        Alice::Dungeon.lose!
        "Eep! After wandering around in the dark room for a moment, the party has been eaten by a grue!"
      end
    end
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
        room[:room].lock_door(Alice::Place.opposite_direction(locked_exit))
      end
    end
  end

  def lock_door(direction)
    self.exits ||= (random_exits | ['direction']).flatten.compact.uniq
    self.locked_exit = direction
    self.save
  end

  def neighbors
    self.exits.inject([]) do |rooms, exit|
      room =   exit == 'north' && Alice::Place.place_to('north', false)
      room ||= exit == 'south' && Alice::Place.place_to('south', false)
      room ||= exit == 'east'  && Alice::Place.place_to('east', false)
      room ||= exit == 'west'  && Alice::Place.place_to('west', false)
      rooms << { direction: exit, room: room }
      rooms
    end
  end

  def origin_square?
    self.x == 0 && self.y == 0
  end

  def place_grue
    return false if self.origin_square?
    return true if has_grue?
    odds = self.is_dark? ? 7 : 20
    if Alice::Util::Randomizer.one_chance_in(odds) && actor = Alice::Actor.unplaced.grue
      actor.update_attribute(:place_id, self.id)
    end
  end

  def place_item
    return false if self.origin_square?
    if Alice::Util::Randomizer.one_chance_in(5) && item = Alice::Item.unplaced.unclaimed.sample
      item.update_attribute(:place_id, self.id)
    end
  end

  def place_actor
    return false if self.origin_square?
    if Alice::Util::Randomizer.one_chance_in(10) && actor = Alice::Actor.in_play.unplaced.sample
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