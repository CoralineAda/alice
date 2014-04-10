module Alice

  class Catchphrase

    include Mongoid::Document
    field :text
    belongs_to :actor 

  end

end