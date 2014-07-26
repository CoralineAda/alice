class Wand

  include Mongoid::Document
  include Mongoid::Timestamps

  include Alice::Behavior::Searchable
  include Alice::Behavior::Ownable
  include Alice::Behavior::Placeable

  field :name
  field :effect_method
  field :charges, type: Integer, default: 3
  field :is_weapon, type: Boolean, default: false

  index({ name: 1 }, { unique: true })
  index({ is_weapon: 1 }, { unique: false })

  belongs_to  :actor
  belongs_to  :user, inverse_of: :items
  belongs_to  :place

  validates_uniqueness_of :name

  EFFECT_METHODS = [
    :light, :dark, :summon, :appear, :teleport, :fruitcake
  ]

  def self.sweep
    all.map{|wand| wand.remove unless item.actor? || item.user?}
    weapons.map(&:remove)
   end

  def self.weapons
    where(is_weapon: true)
  end

  def employ
    return unless EFFECT_METHODS.include?(self.effect_method)
    message = self.send(self.effect_method)
    self.update_attributes(charges: self.charges - 1)
    if self.charges == 0
      message << " The wand fizzles and crumbles."
      remove
      self.update_attributes(charges: 3)
    end
    message
  end

  def appear
    item = Item.unclaimed.unplaced.sample
    Place.current.items << item
    "#{item.name_with_article} appears out of nowhere."
  end

  def dark
    Place.current.lights_out
    "The room suddenly goes pitch black!"
  end

  def fruitcake
    Item.deliver_fruitcake(self.owner)
    "#{self.owner.current_nick} has received a special gift!"
  end

  def light
    Place.current.illuminate
    "The room is suddenly illuminated!"
  end

  def summon
    Actor.random.summon_for(self.owner.primary_nick, true)
  end

  def teleport
    Place.set_current_room(Place.all.sample)
    message = "The room spins and everything goes black... "
    message << Place.current.describe
  end

end