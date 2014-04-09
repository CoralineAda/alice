class Alice::Actor

  include Mongoid::Document
  include Mongoid::Timestamps
  include Alice::Behavior::Searchable
  include Alice::Behavior::Emotes
  include Alice::Behavior::Steals
  include Alice::Behavior::Placeable

  field :name
  field :description
  field :last_theft, type: DateTime
  field :points
  
  validates_uniqueness_of :name

  has_many   :beverages
  has_many   :items
  belongs_to :place

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

  def do_something
    return unless Alice::Randomizer.one_chance_in(10)
    self.public_send(Alice::Actor.actions.sample)
  end

  def brew
    Alice::Beverage::
    message = "#{Alice::Util::Mediator.bot_name} #{}"
  end

  def description
    "Just your run-of-the-mill #{self.proper_name}."
  end

  def drink

  end

  def is_bot?
    false
  end

  def proper_name
    self.name
  end

  def talk

  end

  def target
    (Alice::User.active | Alice::User.online).sample
  end

end