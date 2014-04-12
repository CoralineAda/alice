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

  def self.random
    excludes(is_grue: true).sample
  end

  def self.grue
    where(is_grue: true).first
  end

  def self.observer
    Alice::Actor.is_present.sample
  end

  def self.is_present
    where(place_id: Alice::Place.current.id)
  end

  def self.in_play
    where(in_play: true)
  end

  def self.malleable
    where(permanent: false)
  end

  def self.reset_all
    all.each{|actor| actor.in_play = false; actor.place_id = nil; actor.save}
    10.times{create(name: Alice::Util::Randomizer.specific_person)}
    all.sample(10).map(&:put_in_play)
    grue.put_in_play
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

  def put_in_play
    self.in_play = true
    self.description = nil
    ensure_description
    save
  end

  def ensure_description
    self.description ||= Alice::Util::Randomizer.actor_description(self.name)
  end

  def do_something
    self.public_send(Alice::Actor.actions.sample)
  end

  def brew
    beverage = Alice::Beverage.brew_random
    self.beverages << beverage
    "#{Alice::User.bot.observe_brewing(beverage.name, self.proper_name)}"
  end

  def check_action
    return unless Alice::Util::Randomizer.one_chance_in(10)
  end

  def describe
    check_action
    message = ""
    message << "#{proper_name} is #{self.description}. "
    message << "#{self.inventory}. "
    message << check_score
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
    self.place = Alice::Place.place_to(direction, false)
  end

  def talk
    if message = Alice::Util::Randomizer.one_chance_in(2) && self.catchphrases.sample
      "says '#{message.text}.'"
    elsif message = [Alice::Factoid.random.formatted(false), Alice::Oh.random.formatted(false)].compact.sample
      "says \"#{message}.\""
    else
      "says nothing."
    end
  end

  def target
    (Alice::User.active | Alice::User.online).sample
  end

end