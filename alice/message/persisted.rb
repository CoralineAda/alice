module Message
  class Persisted

    include Mongoid::Document
    include Mongoid::Timestamps

    field :message
    field :context_id

    belongs_to :context
    store_in collection: "alice_messages"

  end
end
