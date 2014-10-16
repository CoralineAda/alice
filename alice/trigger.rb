class Trigger

  include Mongoid::Document

  field :verb
  field :synonyms, type: Array, default: []
  field :method_name

  validates_uniqueness_of :verb

  def self.from(verb)
    (where(verb: verb) | any_in(synonyms: verb)).first
  end

  def with(object)
    @trigger_object = object
    self
  end

  def do
    @trigger_object.public_send(self.method_name)
  end

end
