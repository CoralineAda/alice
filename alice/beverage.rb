class Alice::Beverage

  include Mongoid::Document
  include Mongoid::Timestamps
  include Alice::Behavior::Searchable
  include Alice::Behavior::Tradeable

  field :name

  validates_uniqueness_of :name

  belongs_to :user

  attr_accessor :message

  def self.with_owner_names
    all.map(&:user).uniq.map(&:drinks)
  end

  def self.list
    return "Someone needs to brew some drinks, we're dry!" if count == 0
    "Our beverage collection includes #{drinks_with_owners.to_sentence}."
  end

  def spill
    self.destroy && Randomizer.spill_message(self.name, owner)
  end

  def drink
    self.destroy
    message = Randomizer.drink_message
    message << Randomizer.effect_message if rand(3) == 1 
    message
  end

end

