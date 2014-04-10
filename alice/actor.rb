class Alice::Actor

  include Mongoid::Document
  include Mongoid::Timestamps
  include Alice::Behavior::Searchable
  include Alice::Behavior::Emotes
  include Alice::Behavior::Steals
  include Alice::Behavior::Placeable
  include Alice::Behavior::HasInventory
  include Alice::Behavior::Scorable
  
  field :name
  field :description
  field :last_theft, type: DateTime
  field :points, type: Integer, default: 0
  
  validates_presence_of :name
  validates_uniqueness_of :name

  has_many   :beverages
  has_many   :items
  belongs_to :place

  before_create :ensure_description

  def self.observer
    Alice::Actor.present.sample
  end

  def self.present
    where(place_id: Alice::Place.current.id)
  end

  def self.reset_all
    update_all(place_id: nil)
  end

  def self.actions
    [
      :brew,
      :drink,
      :spill,
      :drop,
      :pick_pocket,
      :move,
      :talk
    ]
  end

  def ensure_description
    self.description ||= Alice::Util::Randomizer.actor_description(self.name)
  end

  def do_something
    return unless Alice::Util::Randomizer.one_chance_in(10)
    self.public_send(Alice::Actor.actions.sample)
  end

  def brew
    beverage = Alice::Beverage.brew_random
    self.beverages << beverage
    "#{Alice::User.bot.observe_brewing(beverage.name, self.proper_name)}"
  end

  def describe
    message = ""
    message << "#{proper_name} is #{self.description}. "
    message << "#{self.inventory}. "
    message << "They currently have #{self.points} points. "
    message
  end

  def is_present?
    self.place == Alice::Place.current
  end

  def spill
    return "#{proper_name } fumbles with an empty cup." unless beverages.present?
    beverages.sample.spill
  end

  def drink
    return "#{proper_name } looks thirsty." unless beverages.present?
    beverages.sample.drink
  end

  def is_bot?
    false
  end

  def is_present?
    self.place == Alice::Place.current
  end

  def proper_name
    self.name
  end

  def drop
    return unless self.items.present?
    self.items.sample.drop
  end

  def pick_pocket(attempts=0)
    if thing = Alice::User.active_and_online.map{|user| user.items.sample}.compact.sample
      steal(thing.name)
    else
      "#{proper_name} looks around slyly."
    end
  end

  def move
    direction = Alice::Place.current.exits.sample
    self.place = Alice::Place.move_to(direction, false)
  end

  def talk
    return unless topic = [Alice::Factoid.random.formatted(false), Alice::Oh.random.formatted(false)].compact.sample
    "#{Alice::Util::Randomizer.says} \"#{topic}.\""
  end

  def target
    (Alice::User.active | Alice::User.online).sample
  end

end