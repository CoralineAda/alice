class Alice::Oh

  include Mongoid::Document
  include Behavior::Samples

  field :text

  def formatted(prefix=true)
    message = ""
    message << Alice::Util::Randomizer.oh_prefix if prefix
    message << text
    message
  end

end