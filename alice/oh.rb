class Alice::Oh

  include Mongoid::Document

  field :text

  def self.random
    all.sample
  end

  def formatted(prefix=true)
    message = ""
    message << Alice::Util::Randomizer.oh_prefix if prefix
    message << text
    message
  end

end