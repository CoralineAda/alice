class Alice::Actor

  include Mongoid::Document
  include Mongoid::Timestamps
  include Alice::Behavior::Searchable
  include Alice::Behavior::Emotes

  field :name

  validates_uniqueness_of :name

  belongs_to :place

end