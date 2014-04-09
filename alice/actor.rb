class Alice::Actor

  include Mongoid::Document
  include Mongoid::Timestamps
  include Alice::Behavior::Searchable
  include Alice::Behavior::Emotes
  include Alice::Behavior::Steals

  field :name
  field :last_theft, type: DateTime
  field :points
  
  validates_uniqueness_of :name

  has_many   :beverages
  has_many   :items
  belongs_to :place

  def is_bot?
    false
  end

  def proper_name
    self.name
  end

end