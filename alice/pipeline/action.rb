module Pipeline
  class Action

    include Mongoid::Document

    field :trigger
    field :is_primary, type: Boolean
    field :description
    field :trigger_method

    index({ trigger: 1 }, { unique: true })

    validates_presence_of :trigger, :description

    belongs_to :machine

    store_in collection: "alice_actions"

    def self.triggered_by(action)
      where(trigger: action)
    end

    def self.primary
      where(is_primary: true)
    end

  end
end