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
  
  index({ x: 1, y: 1 },    { unique: true })
  index({ is_current: 1 }, { unique: false })
  
  after_create :place_item
  after_create :place_actor
  after_create :ensure_description

  DIRECTIONS = ['north', 'south', 'east', 'west']

  def self.current
    where(:is_current => true).last || all.sample || generate!
  end

  def self.generate!(args={})
    room = create(
      exits: (random_exits | [args[:entered_from]]).flatten.compact.uniq,
      x: args[:x] || 0,
      y: args[:y] || 0,
      is_current: args[:is_current]
    )
    room.update_attribute(:description, random_description(room))
    room
  end

  def self.go(direction)
    return false unless current.exits.include?(direction.downcase)
    move_to(direction)
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
    return room.enter if party_moving
    return room
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

  def self.random_description(room)
    return "It is pitch black. You are likely to be eaten by a grue. " if room.origin_square?
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

  def enter
    Alice::Place.set_current_room(self)
    handle_grue || self.describe
    return true
  end

  def contains?(noun)
    noun.place == self
  end

  def contents
    return unless has_item? || has_actor?
    contents = ""
    contents << "You notice #{self.actors.map(&:name).to_sentence} #{Alice::Util::Randomizer.action}. " if self.has_actor?
    contents << "Contents: #{self.items.map(&:name).to_sentence}. " if has_item?
    contents
  end

  def describe
    if self.origin_square?
      "#{self.description}. #{contents} Exits: #{exits.to_sentence}."
    else
      "You are in #{self.description}. #{contents} Exits: #{exits.to_sentence}."
    end
  end

  def ensure_description
    return true if self.description.present?
    update_attribute(:description, Alice::Place.random_description(self))
  end

  def handle_grue
    return if self.origin_square?
    return unless Alice::Util::Randomizer.one_chance_in(13)
    if user = Alice::User.with_weapon.sample 
      "#{user.proper_name} slays the grue!"
    else
      "You have been eaten by a grue!"
    end
  end    

  def has_item?
    self.items.present?
  end

  def has_actor?
    self.actors.present?
  end

  def place_item
    if Alice::Util::Randomizer.one_chance_in(10) && item = Alice::Item.unplaced.sample
      item.update_attribute(:place_id, self.id)
    end
  end

  def place_actor
    if Alice::Util::Randomizer.one_chance_in(10) && actor = Alice::Actor.unplaced.sample
      actor.update_attribute(:place_id, self.id)
    end
  end

  def origin_square?
    self.x == 0 && self.y == 0
  end

end