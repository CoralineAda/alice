class Oh

  include Mongoid::Document
  include Behavior::Samples

  field :text

  store_in collection: :alice_oh

  def self.random
    all.sample
  end

end