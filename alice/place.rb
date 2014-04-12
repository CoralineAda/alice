class Alice::Place

  include Mongoid::Document

  field :description
  field :exits
  field :is_current, type: Boolean
  field :x, type: Integer
  field :y, type: Integer
  field :is_dark, type: Boolean

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
      y = current.y + 1
    elsif direction == 'south'
      y = current.y - 1
    else
      y = current.y
    end

    if direction == 'west'
      x = current.x + 1
    elsif direction == 'east'
      x = current.x - 1
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

  def enter
    Alice::Place.set_current_room(self)
    handle_grue || self.describe
  end

  def contains?(noun)
    noun.place == self
  end

  def contents
    return unless has_item? || has_actor?
    contents_text = ""
    contents_text << "You notice #{self.actors.map(&:name).to_sentence} #{Alice::Util::Randomizer.action}. " if self.has_actor?
    contents_text << "Contents: #{self.items.map(&:name).to_sentence}. " if has_item?
    contents_text
  end

  def describe
    if self.origin_square?
      message = "#{self.description}. #{contents} Exits: #{exits.to_sentence}. "
    elsif self.is_dark?
      message = "It is pitch black and you can't see a thing. What if there is a grue?"
    else
      message = "You are in #{self.description}. #{contents} Exits: #{exits.to_sentence}. "
    end
    message
  end

  def ensure_description
    return true if self.description.present?
    update_attribute(:description, Alice::Place.random_description(self))
  end

  def handle_grue
    if self.actors.include? Alice::Actor.grue
      if user = Alice::User.with_weapon.sample 
        Alice::Dungeon.win!
        "#{user.proper_name} slays the grue!"
      else
        Alice::Dungeon.lose!
        "The party has been eaten by a grue!"
      end
    end
  end    

  def has_item?
    self.items.present?
  end

  def has_actor?
    self.actors.present?
  end

  def has_grue?
    self.actors.grue.present?
  end

  def place_grue
    return false if self.origin_square?
    return true if has_grue?
    odds = self.is_dark? ? 5 : 20
    if Alice::Util::Randomizer.one_chance_in(odds) && actor = Alice::Actor.unplaced.grue
      actor.update_attribute(:place_id, self.id)
    end
  end

  def place_item
    return false if self.origin_square?
    if Alice::Util::Randomizer.one_chance_in(10) && item = Alice::Item.unplaced.sample
      item.update_attribute(:place_id, self.id)
    end
  end

  def place_actor
    return false if self.origin_square?
    if Alice::Util::Randomizer.one_chance_in(10) && actor = Alice::Actor.in_play.unplaced.sample
      actor.update_attribute(:place_id, self.id)
    end
  end

  def origin_square?
    self.x == 0 && self.y == 0
  end

end