class Item

  include Mongoid::Document
  include Mongoid::Timestamps
  include Alice::Behavior::Searchable
  include Alice::Behavior::Ownable
  include Alice::Behavior::Placeable

  ALLOWED_PROPERTIES = [
    :smell,
    :taste,
    :image,
    :url,
    :description
  ]

  store_in collection: "alice_items"

  field :name
  field :description
  field :properties,          type: Hash,    default: {}
  field :is_cursed,           type: Boolean
  field :is_hidden,           type: Boolean
  field :is_weapon,           type: Boolean
  field :is_game,             type: Boolean
  field :is_hidden,           type: Boolean
  field :is_key,              type: Boolean
  field :is_readable,         type: Boolean
  field :picked_up_at,        type: DateTime
  field :theft_attempt_count, type: Integer, default: 0
  field :creator_id

  index({ name: 1 },        { unique: true, })
  index({ is_cursed: 1 },   { unique: false })
  index({ is_hidden: 1 },   { unique: false })
  index({ is_weapon: 1 },   { unique: false })
  index({ is_game: 1 },     { unique: false })
  index({ is_hidden: 1 },   { unique: false })
  index({ is_key: 1 },      { unique: false })
  index({ is_readable: 1 }, { unique: false })
  index({ creator_id: 1 },  { unique: false })

  validates_uniqueness_of :name
  validates_presence_of :name

  attr_accessor :is_ephemeral, :message

  belongs_to  :actor
  belongs_to  :user, inverse_of: :items
  belongs_to  :place

  before_create :check_if_cursed
  before_create :check_if_not_ephemeral
  before_create :ensure_description

  def self.already_exists?(name)
    where(name: name).present?
  end

  def self.create_defaults
    create(name: Alice::Util::Randomizer.game, is_game: true)
    (rand(10) + 2).times {|i| create(name: Alice::Util::Randomizer.item) }
    (rand(10) + 2).times {|i| create(name: Alice::Util::Randomizer.reading_material, is_readable: true) }
    (rand(10) + 2 / 2).times {|i| create(name: Alice::Util::Randomizer.weapon, is_weapon: true) }
    (rand(10) + 2 / 2).times {|i| create(name: Alice::Util::Randomizer.keys, is_key: true) }
  end

  def self.cursed
    where(is_cursed: true).excludes(name: 'fruitcake')
  end

  def self.deliver_fruitcake(victim=nil)
    victim ||= User.active_and_online.sample
    victim && victim.items << Item.fruitcake
  end

  def self.ephemeral
    new(name: "thing that you don't have", ephemeral: true)
  end

  def self.forge(name, user)
    new_item = new(
      name: name,
      user: user,
      creator_id: user.try(:id),
    )
    new_item.creator && new_item.creator.score_points
    new_item.check_if_cursed
    new_item.ensure_description
    new_item.save
    "#{new_item.owner.current_nick} forges a #{name} #{Alice::Util::Randomizer.forge}."
  end

  def self.fruitcake
    where(name: 'fruitcake').last || create(
      name: 'fruitcake',
      description: "It's the dread fruitcake!",
      is_cursed: true
    )
  end

  def self.games
    where(is_game: true)
  end

  def self.hidden
    where(is_hidden: true)
  end

  def self.keys
    where(is_key: true)
  end

  def self.inventory_from(owner, list)
    stuff = Alice::Util::Randomizer.empty_pockets if list.empty?
    stuff ||= list.map(&:name_with_article).to_sentence
    "#{owner.proper_name}'s #{Alice::Util::Randomizer.item_container} #{stuff}."
  end

  def self.reading_material
    where(is_readable: true)
  end

  def self.reset_cursed
    cursed.update_all(is_cursed: false)
  end

  def self.sorted
    all.sort_by(&:name)
  end

  def self.sweep
    all.map{|item| item.delete unless item.actor? || item.user?}
    keys.map(&:delete)
    weapons.map(&:delete)
  end

  def self.weapons
    where(is_weapon: true)
  end

  def check_if_cursed
    self.is_cursed ||= rand(10) == 1
    true
  end

  def check_if_not_ephemeral
    ! self.is_ephemeral
  end

  def creator
    User.where(id: self.creator_id).first || User.new(primary_nick: "nobody")
  end

  def describe
    text = []
    text << self.properties[:description] || self.description
    text << "#{creator.proper_name} was its creator, "
    text << "judging by the #{creator.new_record? ? 'lack of a' : ''} maker's mark."
    text << "Might be fun to read." if self.is_readable?
    text << "Might make a decent weapon." if self.is_weapon?
    text << "Might be fun to play." if self.is_game?
    text << "Could come in handy with those pesky locked doors." if self.is_key?
    text << "It probably tastes #{self.properties[:taste]}." if self.properties[:taste]
    text << "From here, it smells #{self.properties[:smell]}." if self.properties[:smell]
    text << "Find it online at #{self.properties[:url]}." if self.properties[:url]
    text << "It looks remarkably like this: #{properties[:image]}" if self.properties[:image]
    text.join(" ").gsub(/\.\. /, '. ').gsub(/^ /,'')
  end

  def destruct
    return "The #{self.name} is cursed and cannot be destroyed so easily." if self.is_cursed
    self.delete
    "#{owner_name} #{Alice::Util::Randomizer.destroy_message(self.name)}"
  end

  def drink
    "It's undrinkable."
  end

  def eat
    "Please don't put that in your mouth."
  end

  def ensure_description
    self.description ||= Alice::Util::Randomizer.item_description(self.name)
  end

  def name_with_appendix
    self.is_game? && "#{self.name} game" || self.name
  end

  def name_with_article
    Alice::Util::Sanitizer.process("#{Alice::Util::Randomizer.article} #{self.name_with_appendix}")
  end

  def play
    return "It's not safe to play with #{name_with_article}!" unless self.is_game?
    if self.user.can_play_game?
      self.user.score_points(3)
      "#{owner_name} #{Alice::Util::Randomizer.play} a game of #{name} and wins!"
    else
      self.user.score_points(-3)
      "#{owner_name} #{Alice::Util::Randomizer.play} a game of #{name} but loses."
    end
  end

  def point_value
    self.theft_attempt_count > 0 ? self.theft_attempt_count : 1
  end

  def randomize_name
    new_name = self.name
    new_name = "#{Alice::Util::Randomizer.material} #{new_name}" if Item.where(name: new_name).first
    new_name = "#{new_name} with SN #{Time.now.to_i}" if Item.where(name: new_name).first
    self.name = new_name
  end

  def read
    return "#{name_with_article} is not a very interesting read." unless self.is_readable?
    return "It reads, \"#{Factoid.sample.formatted(false)}\"."
  end

  def increment_theft_attempts
    update_attribute(:theft_attempt_count, self.theft_attempt_count + 1)
  end

  def reset_theft_attempts
    update_attribute(:theft_attempt_count, 0)
  end

  def set_property(key, value)
    return unless ALLOWED_PROPERTIES.include? key.to_sym
    self.properties[key.to_sym] = value
    self.save
  end

end

