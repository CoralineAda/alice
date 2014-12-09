class Beverage

  include Mongoid::Document
  include Mongoid::Timestamps
  include Behavior::Searchable
  include Behavior::Ownable
  include Behavior::Placeable

  field :name
  field :description
  field :is_hidden, type: Boolean
  field :is_alcohol, type: Boolean
  field :picked_up_at, type: DateTime
  field :creator_id

  store_in collection: "alice_beverages"

  validates_presence_of :name
  validates_uniqueness_of :name

  index({ name: 1 },        { unique: true, })
  index({ is_hidden: 1 },   { unique: false })
  index({ creator_id: 1 },  { unique: false })

  belongs_to :actor
  belongs_to :user
  belongs_to :place

  before_create :set_alcohol
  before_create :ensure_description

  def self.already_exists?(name)
    where(name: /name/i).present?
  end

  def self.brew(name, user)
    return Util::Constants::THERE_CAN_BE_ONLY_ONE if user.beverages.already_exists?(name)
    return Util::Constants::THATS_ENOUGH_DONTCHA_THINK unless user.can_brew?
    if beverage = user.beverages.create(name: name, user: user)
      Alice::Util::Randomizer.brew_observation(name, user.current_nick, alcohol: beverage.is_alcohol?)
    else
      Util::Constants::UH_OH
    end
  end

  def self.brew_random
    new.tap do |beverage, beer = Beer.random|
      beverage.name = "#{beer.container} of #{beer.name}",
      beverage.description = beer.description
    end
  end

  def self.consume(name, user)
    if beverage = user.beverages.like(name)
      beverage.drink
    else
      Util::Constants::NO_SUCH_DRINK
    end
  end

  def self.for_user(user)
    where(user_id: user.id)
  end

  def self.inventory_from(owner, list)
    stuff = list.present? && list.map(&:name_with_article).to_sentence || "no drinks."
    "#{owner.proper_name}'s cooler is stocked with #{stuff}"
  end

  def self.sorted
    all.asc(&:name)
  end

  def self.sweep
    all.map{|item| item.delete unless item.actor? || item.user?}
  end

  def is_coffee?
    Dictionary.is_a?(:coffee_or_tea, self.name) == true
  end

  def set_alcohol
    return if Dictionary.is_a?(:coffee_or_tea, self.name) == true
    beer = Beer.search(self.name)
    cocktail = MixedDrink.search(self.name)
    if drink = Parser::LanguageHelper.similar_to(self.name, beer.canonical_name) && beer ||
               Parser::LanguageHelper.similar_to(self.name, cocktail.canonical_name) && cocktail.result
      self.name = "#{drink.container.downcase} of #{self.name}"
      self.description = drink.description
      self.is_alcohol = true
    end
  end

  def drink
    message = Alice::Util::Randomizer.drink_message(self.name, owner_name)
    if self.is_potion? || self.is_alcohol?
      effect = [:drunk, :dazed, :disoriented].sample
      message << " In addition to feeling a little #{effect.to_s}, " + Alice::Util::Randomizer.effect_message(self.name, owner_name)
      self.user.filters << effect
      self.user.filters.uniq!
      self.user.filter_applied = Time.now
      self.user.save
    end
    if self.is_coffee?
      message << " Your head seems to have cleared up a bit."
      self.user.filters = []
      self.user.save
    end
    self.delete
    message
  end

  def describe
    self.description
  end

  def ensure_description
    self.description ||= Alice::Util::Randomizer.drink_description(self.name)
  end

  def is_cursed?
    false
  end

  def is_potion?
    self.name =~ /potion/
  end

  def randomize_name
    new_name = self.name
    new_name = "#{Alice::Util::Randomizer.beverage_container} of #{self.name}" if Beverage.where(name: new_name).first
    new_name = "#{Alice::Util::Randomizer.material} #{new_name}" if Beverage.where(name: new_name).first
    new_name = "#{new_name} with SN #{Time.now.to_i}" if Beverage.where(name: new_name).first
    self.name = new_name
  end

  def spill
    self.destroy && Alice::Util::Randomizer.spill_message(self.name, owner_name)
  end

  def name_with_article
    Alice::Util::Sanitizer.process("#{Alice::Util::Randomizer.article} #{self.name}")
  end

end
