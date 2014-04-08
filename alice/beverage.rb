class Alice::Beverage

  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  field :effect

  attr_accessor :message

  belongs_to :user

  def self.from(string)
    names = Alice::Parser::NgramFactory.new(string.gsub(/[^a-zA-Z0-9\_\ ]/, '')).omnigrams
    names = names.map{|g| g.join ' '}
    names.map{|name| Alice::Beverage.like(name) }.flatten.compact || []
  end

  def self.like(name)
    where(name: /#{name}$/i)
  end

  def owner
    self.user.primary_owner.capitalize
  end

  def drop
    self.destroy && drop_message
  end

  def drink
    self.destroy && [consume_message, effect_message].join(" ")
  end

  def effect_message
    return unless rand(3) == 0
    [
      "#{owner} grows bat wings and flits around the room.",
      "#{owner}'s head feel like it's deflating like a balloon. Time to get the bicycle pump!",
      "The drink makes #{owner} feel a little dizzy.",
      "#{owner}'s heart grows three sizes.",
      "#{owner} achieves clarity of thought.",
      "The drink makes #{owner} want to contemplate the meaning of life.",
      "The drink really sobers up #{owner}.",
      "The drink makes #{owner} feel like burping.",
      "The drink gives #{owner} a ton of energy.",
      "The drink seems to drain #{owner}'s energy.",
      "#{owner} turns insubstantial.",
      "#{owner}'s wounds are healed!",
      "#{owner} feels like singing!",
      "#{owner} can move at double speed.",
      "#{owner} gains the power of invisibility.",
      "#{owner} gains the ability to pocket small items.",
      "#{owner} looks a bit ill.",
      "#{owner} gains immunity to all elephant-based spells.",
      "#{owner} feels a strong urge to move #{Alice::Place.last.exits.sample}.",
      "#{owner} hears a strange voice calling from somewhere to the #{Alice::Place.last.exits.last}.",
      "The drink sends a shiver to go down #{owner}'s spine.",
      "#{owner} is filled with the sudden urge to defy gravity.",
      "#{owner} tries hard not to think of flying monkeys.",
      "#{owner} has a sudden thirst for blood.",
      "#{owner} still feels strangely parched.",
      "#{owner} feels a sudden urge to dance."
    ].sample.gsub("the the").gsub("the ye", "ye")
  end

  def drop_message
    [
      "#{owner} spills the #{self.name} all over the floor.",
      "#{owner} spills the #{self.name} down the front of their shirt.",
      "#{owner} knocks the #{self.name} over.",
      "#{owner} slowly pours the #{self.name} out.",
      "#{owner} cries over spilled #{self.name}.",
      "The #{self.name} shatters on the floor!",
      "#{owner} lets out a mighty 'Whoop!' and throws the #{self.name} against a wall.",
      "#{owner} slyly dumps out the #{self.name}."
    ].sample.gsub("the the").gsub("the ye", "ye")
  end

  def consume_message
    [
      "#{owner} slams the #{self.name}.",
      "#{owner} sip the #{self.name}.",
      "#{owner} imbibes the #{self.name}.",
      "#{owner} gulps the #{self.name}.",
      "#{owner} quaffs the entire #{self.name}.",
      "#{owner} drains the #{self.name}.",
      "#{owner} consumes all of the #{self.name}.",
    ].sample.gsub("the the").gsub("the ye", "ye")
  end

  def pass_to(owner)
    if recipient = Alice::User.find_or_create(owner)
      if recipient.is_bot?
        self.message = "#{recipient.primary_owner} does not accept drinks."
      end
      if transferable?
        self.message = "You pass the #{self.name} to #{recipient.primary_owner.capitalize}."
        self.message = self.message.gsub("the the", "the").gsub("the ye", "ye")
        self.user = recipient
        self.save
      end
    else
      self.message = "You can't share the #{self.name} with an imaginary friend. Maybe you've had too much?" unless recipient
    end
    self
  end
  
  def owner
    self.user.primary_owner.capitalize
  end
end

