class Alice::Place

  include Mongoid::Document

  field :description
  field :exits
  field :is_current, type: Boolean
  field :x, type: Integer
  field :y, type: Integer

  has_many :items
  has_many :beverages
  has_many :actors
  
  DIRECTIONS = ['north', 'south', 'east', 'west']

  def self.current
    where(:is_current => true).current || all.sample || generate!
  end

  def self.generate!(args={})
    create(
      description: random_description,
      exits: (random_exits | [args[:entered_from]]).flatten.compact.uniq,
      x: args[:x] || 0,
      y: args[:y] || 0,
      is_current: args[:is_current]
    )
  end

  def self.go(direction)
    return false unless current.exits.include?(direction.downcase)
    move_to(direction) && true
  end

  def self.move_to(direction, party_moving=true)
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

    room = Alice::Place.where(x: x, y: y).first
    room ||= Alice::Place.generate!(x: x, y:y, entered_from: opposite_direction(direction))
    if party_moving
      room.enter
    else
      room
    end
  end

  def self.opposite_direction(direction)
    return 'south' if direction == 'north'
    return 'north' if direction == 'south'
    return 'east' if direction == 'west'
    return 'west' if direction == 'east'
  end

  def self.set_current_room(room)
    Alice::Place.current.update_attribute(:is_current, false)
    room.update_attribute(:is_current, true)
  end

  def self.random_description
    return "It is pitch black. You are likely to be eaten by a grue." if origin_square?
    description = [
      Alice::Util::Randomizer.room_adjective,
      Alice::Util::Randomizer.room_type,
      Alice::Util::Randomizer.room_description,
      '.',
    ].join(' ')
    description << "It is #{brightness}" if Alice::Util::Randomizer.one_chance_in(5)
    description
  end

  def self.random_exits
    DIRECTIONS.sample(rand(2) + 2)
  end

  def enter
    Alice::Place.set_current_room(self)
    handle_grue && return if has_grue?
  end

  def contains?(noun)
    noun.place_id == self.id
  end

  def contents
    return unless has_item? || has_actor?
    contents = "Contents:"
    contents << "#{self.items.map(&:name).to_sentence}." if self.has_item?
    contents << "#{self.actors.map(&:name).to_sentence}." if self.has_actor?
    contents
  end

  def describe
    if self.origin_square?
      "#{self.description}. #{contents} Exits: #{exits.to_sentence}."
    else
      "You are in #{self.description}. #{contents} Exits: #{exits.to_sentence}."
    end
  end

  def handle_grue
    if user = Alice::User.with_weapon.sample 
      "#{user.proper_name} slays the grue!"
    else
      "You have been eaten by a grue!"
    end
  end    

  def has_grue?
    return false if self.origin_square?
    return false unless Alice::Randomizer.one_chance_in(20)
    @has_grue ||= true
  end

  def has_item?
    return true if self.items.present?
    return if self.origin_square?
    return unless Alice::Util::Randomizer.one_chance_in(10)
    return unless item = Alice::Item.unclaimed.unplaced.sample
    item.update_attribute(place: self)
  end

  def has_actor?
    return true if self.actors.present?
    return if self.origin_square?
    return unless Alice::Util::Randomizer.one_chance_in(10)
    return unless actor = Alice::Actor.unplaced.sample
    actor.update_attribute(place: self)
  end

  def origin_square?
    self.x == 0 && self.y == 0
  end

end