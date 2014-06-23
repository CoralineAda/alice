class Dictionary

  def self.is_a?(category, thing)
    return :params_reversed if self.respond_to?(thing)
    return :unknown unless self.respond_to?(category)
    self.public_send(category, parsed_thing(thing))
  end

  def self.coffee_or_tea(thing)
    (['cup', 'cuppa', 'pot', 'kettle', 'mug'] & thing).count > 0
  end

  def self.parsed_thing(thing)
    thing.split
  end

end