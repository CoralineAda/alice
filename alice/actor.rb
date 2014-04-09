class Alice::Actor

  include Mongoid::Document
  include Mongoid::Timestamps
  include Alice::Behavior::Searchable
  include Alice::Behavior::Emotes
  include Alice::Behavior::Steals
  include Alice::Behavior::Placeable
  include Alice::Behavior::HasInventory

  field :name
  field :description
  field :last_theft, type: DateTime
  field :points
  
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

  def self.actions
    [
      :brew,
      :drink,
      :steal,
      :move,
      :talk
    ]
  end

  def ensure_description
    self.description ||= Alice::Randomizer.actor_description(self.name)
  end

  def do_something
    return unless Alice::Randomizer.one_chance_in(10)
    self.public_send(Alice::Actor.actions.sample)
  end

  def brew
    beverage = Alice::Beverage.make_random_for(self)
    "#{Alice::User.bot.observe_brewing(beverage.name, self.proper_name}"
  end

  def describe
    message = ""
    message << "#{proper_name} #{self.description}. "
    message << "#{self.inventory}. "
    message << "They currently have #{self.points} points. "
    message
  end

  def drink
    return beverage = unless actor.beverages.first
    beverage.drink
  end

  def is_bot?
    false
  end

  def proper_name
    self.name
  end

  def steal

  end

  def talk

  end

  def target
    (Alice::User.active | Alice::User.online).sample
  end

end