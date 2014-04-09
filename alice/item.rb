class Alice::Item

  include Mongoid::Document
  include Mongoid::Timestamps
  include Alice::Behavior::Searchable
  include Alice::Behavior::Ownable
  include Alice::Behavior::Placeable

  field :name
  field :description
  field :is_cursed, type: Boolean
  field :is_hidden, type: Boolean
  field :is_weapon, type: Boolean
  field :is_readable, type: Boolean
  field :picked_up_at, type: DateTime
  field :creator_id

  validates_uniqueness_of :name
  
  attr_accessor :message

  belongs_to  :actor
  belongs_to  :user, inverse_of: :items
  belongs_to  :place
  has_many    :actions

  before_create :check_cursed

  def self.already_exists?(name)
    like(name).present?
  end

  def self.fruitcake
    where(name: 'fruitcake') || create(name: 'fruitcake', is_cursed: true)
  end

  def self.sweep
    all.map{|item| item.delete unless item.actor? || item.user?}
  end

  def self.weapons
    where(is_weapon: true)
  end

  def self.inventory_from(owner, list)
    stuff = Alice::Util::Randomizer.empty_pockets if list.empty?
    stuff ||= list.map(&:name_with_article).to_sentence
    "#{owner.proper_name}'s #{Alice::Util::Randomizer.item_container} #{stuff}."
  end

  def self.total_inventory
    return "We have nothing! Someone needs to forge some stuff, possibly some things as well!" if count == 0
    "Our equipment includes #{all.sorted.map(&:name_with_article).to_sentence}."
  end

  def self.sorted
    sort(&:name)
  end

  def check_cursed
    self.is_cursed ||= rand(10) == 1
    true
  end

  def creator
    Alice::User.find(self.creator_id)
  end

  def description
    @description || Alice::Util::Randomizer.item_description(self.name)
  end

  def name_with_article
    Alice::Util::Sanitizer.process("#{Alice::Util::Randomizer.article} #{self.name}")
  end
  
  def read
    return "#{name_with_article} is not readable!" unless self.is_readable?
    return "It says that #{Alice::Factoid.random.formatted(false)}."
  end

end

