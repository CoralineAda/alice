class Alice::Treasure

  include Mongoid::Document
  include Mongoid::Timestamps
  include Alice::Behavior::Searchable
  include Alice::Behavior::Tradeable

  field :name
  field :description
  field :is_cursed, type: Boolean
  field :is_hidden, type: Boolean
  field :picked_up_at, type: DateTime

  validates_uniqueness_of :name
  
  attr_accessor :message

  belongs_to  :user
  belongs_to  :place
  has_many    :actions

  def self.inventory_from(owner, list)
    return Alice::Util::Randomizer.empty_pockets if list.empty?
    stuff = list.map(&:name_with_article).to_sentence
    "#{owner}'s #{Alice::Util::Randomizer.treasure_container} #{stuff}."
  end

  def self.total_inventory
    return "We have nothing! Someone needs to forge some stuff, possibly some things as well!" if count == 0
    return "Our equipment includes #{all.sorted.map(&:name_with_article).to_sentence}."
  end

  def self.sorted
    sort(&:name)
  end

  def initialize(args={})
    self.is_cursed ||= rand(10) == 1
    super
  end

  def name_with_article
    Alice::Util::Sanitizer.process("a #{self.name}")
  end

end

