class Alice::Beverage

  include Mongoid::Document
  include Mongoid::Timestamps
  include Alice::Behavior::Searchable
  include Alice::Behavior::Ownable
  include Alice::Behavior::Placeable

  field :name
  field :description
  field :is_hidden, type: Boolean
  field :picked_up_at, type: DateTime
  field :creator_id

  validates_presence_of :name
  validates_uniqueness_of :name

  index({ name: 1 },        { unique: true, })
  index({ is_hidden: 1 },   { unique: false })
  index({ creator_id: 1 },  { unique: false })

  belongs_to :actor
  belongs_to :user
  belongs_to :place

  before_create :ensure_description

  attr_accessor :message

  def self.already_exists?(name)
    like(name).present?
  end

  def self.sweep
    all.map{|item| item.delete unless item.actor? || item.user?}
  end

  def self.inventory_from(owner, list)
    stuff = list.present? && list.map(&:name_with_article).to_sentence || "no drinks."
    "#{owner.proper_name}'s cooler is stocked with #{stuff}"
  end

  def self.total_inventory
    return "Someone needs to brew some drinks, we're dry!" if count == 0
    "Our beverage collection includes #{with_owner_names.map(&:name_with_article).to_sentence}."
  end

  def self.brew_random
    new(
      name: "#{Alice::Util::Randomizer.beverage_container} of #{Alice::Util::Randomizer.beverage}"
    )
  end

  def self.sorted
    all.sort_by(&:name)
  end

  def self.with_owner_names
    sorted.map(&:user).compact.uniq.map(&:beverages).flatten
  end

  def drink
    self.destroy
    message = Alice::Util::Randomizer.drink_message(self.name, self.owner)
    message << " " + Alice::Util::Randomizer.effect_message(self.name, self.owner) if self.is_potion? || Alice::Util::Randomizer.one_chance_in(4)
    message
  end

  def describe
    self.description
  end

  def ensure_description
    self.description ||= Alice::Util::Randomizer.drink_description(self.name)
  end

  def is_potion?
    self.name =~ 'potion'
  end

  def spill
    self.destroy && Alice::Util::Randomizer.spill_message(self.name, owner)
  end

  def name_with_article
    Alice::Util::Sanitizer.process("#{Alice::Util::Randomizer.article} #{self.name}")
  end

end
