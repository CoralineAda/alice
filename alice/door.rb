class Door

  include Mongoid::Document

  field :from_coords, type: Array, default: []
  field :to_coords,   type: Array, default: []
  field :is_locked,   type: Boolean, default: false

  before_create :lock

  validates_uniqueness_of :from_coords, scope: :to_coords

  def self.from(coords)
    new(from_coords: coords)
  end

  def to(coords)
    self.to_coords = coords
    self
  end

  def lock
    self.is_locked = true if Util::Randomizer.one_chance_in(10)
  end

  def unlock_with(item)
    return false unless item.is_key
    update_attribute(:is_locked, false)
  end

end