class Alice::Factoid

  include Mongoid::Document

  field :text

  belongs_to :user

end