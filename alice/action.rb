class Alice::Action

  include Mongoid::Document

  field :trigger
  field :description

  validates_presence_of :trigger, :description

  belongs_to :treasure

  def self.triggered
    where(trigger: trigger).first
  end

  def emote
    return description
  end

end