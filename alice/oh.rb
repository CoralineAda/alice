class Alice::Oh

  include Mongoid::Document

  field :text

  def self.random
    all.sample
  end

  def formatted
    "#{Alice::Util::Randomizer.oh_prefix} #{text}"
  end

end