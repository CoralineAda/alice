class Catchphrase

  include Mongoid::Document
  include Behavior::Samples

  field :text

  store_in collection: "alice_catchphrases"
  belongs_to :actor

end
