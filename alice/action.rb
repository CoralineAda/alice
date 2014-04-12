class Alice::Action

  include Mongoid::Document

  field :trigger
  field :description
 
  index({ trigger: 1 }, { unique: true })
  
  validates_presence_of :trigger, :description

  belongs_to :item

  def self.triggered
    where(trigger: trigger).first
  end

  def emote
    return description
  end

end