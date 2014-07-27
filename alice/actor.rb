class Actor

  include Mongoid::Document
  include Mongoid::Timestamps
  include Alice::Behavior::Searchable
  include Alice::Behavior::Emotes
  include Alice::Behavior::Steals
  include Alice::Behavior::Speaks
  include Alice::Behavior::Placeable
  include Alice::Behavior::HasInventory
  include Alice::Behavior::Scorable

  store_in collection: "alice_actors"

  field :name
  field :description
  field :last_theft, type: DateTime
  field :points, type: Integer, default: 0
  field :is_grue, type: Boolean
  field :in_play, type: Boolean

  validates_presence_of :name
  validates_uniqueness_of :name

  index({ name: 1 }, { unique: true })

  has_many   :beverages
  has_many   :catchphrases
  has_many   :items
  belongs_to :place

  before_create :ensure_description

  ACTIONS = [
    :brew,
    :drink,
    :spill,
    :drop,
    :pick_pocket,
    :move,
    :talk
  ]

  def self.ensure_grue
    Actor.grue || Actor.create(name: 'Grue', description: "Fearsome! Loathsome! But cuddly!", is_grue: true)
  end

  def self.unknown
    Actor.new(name: "Nobody", description: "Nothing to see here.")
  end

  def self.grue
    where(is_grue: true).first
  end

  def self.in_play
    where(in_play: true)
  end

  def self.observer
    present.random
  end

  def self.present
    where(place_id: Place.current.id)
  end

  def self.random
    excludes(is_grue: true).sample
  end

  def self.reset_all
    all.each{|actor| actor.in_play = false; actor.place_id = nil; actor.save}
    10.times{create(name: Alice::Util::Randomizer.specific_person)}
    all.sample(10).map(&:put_in_play)
    grue.put_in_play
  end

  def add_catchphrase(text)
    self.catchphrases.create(text: text)
  end

  def brew
    self.beverages << Beverage.brew_random
    self.beverages.last
  end

  def describe
    message = []
    message << "#{proper_name} is #{self.description}"
    message << self.inventory_of_items
    message << self.inventory_of_beverages
    message << check_score
    message.compact.join(". ").gsub(/\.\. /, '. ')
  end

  def do_something
    self.public_send(Actor.actions.sample)
  end

  def ensure_description
    self.description ||= Alice::Util::Randomizer.actor_description(self.name)
  end

  def is_present?
    self.place == Place.current
  end

  def drink
    return "#{proper_name } looks thirsty." unless beverages.present?
    beverages.sample.drink
  end

  def drop
    return unless self.items.present?
    self.items.sample.drop
  end

  def is_bot?
    false
  end

  def is_present?
    self.place == Place.current
  end

  def move
    direction = Place.current.exits.sample
    self.place = Place.place_to(direction, false)
  end

  def perform_random_action
    return unless Alice::Util::Randomizer.one_chance_in(10)
    action = ACTIONS.sample
    respond_to?(action) && self.send(action)
  end

  def pick_pocket(attempts=0)
    if thing = User.active_and_online.map{|user| user.items.sample}.compact.sample
      steal(thing.name)
    else
      "#{proper_name} looks around slyly."
    end
  end

  def proper_name
    self.name.to_s.split(" ").map(&:capitalize).join(" ")
  end

  def put_in_play
    self.in_play = true
    reset_description && save
  end

  def reset_description
    self.description = nil
    ensure_description
  end

  def spill
    beverages.present? && beverages.sample.spill
  end

  def summon_for(summoner, force=false)
    return if self.is_bot?
    if self.is_grue?
      return "The image of a fearsome grue appears for a moment, then vanishes, leaving a musky scent lingering in the air."
    end
    if force || Alice::Util::Randomizer.one_chance_in(2)
      put_in_play && Place.current.actors << self
      return "#{proper_name} appears before #{summoner}!"
    else
      Alice::Util::Randomizer.summon_failure(summoner, proper_name)
    end
  end

end
