class Alice::Beverage

  include Mongoid::Document
  include Mongoid::Timestamps

  field :name

  validates_uniqueness_of :name

  attr_accessor :message

  belongs_to :user

  def self.from(string)
    return [] unless string.present?
    names = Alice::Parser::NgramFactory.new(string.gsub(/[^a-zA-Z0-9\_\ ]/, '')).omnigrams
    names = names.map{|g| g.join ' '}
    names.map{|name| Alice::Beverage.like(name) }.flatten.compact || []
  end

  def self.like(name)
    where(name: /#{name}$/i)
  end

  def self.container
    [
      "fridge with",
      "fully stocked bar that includes",
      "six-pack with one last",
      "brown paper bag with"
    ].sample
  end

  def self.list
    return "Someone needs to brew some drinks, we're dry!" if Alice::Beverage.count == 0
    string = ""
    owners = Alice::Beverage.all.map(&:user).uniq
    drinks_with_owners = owners.map(&:drinks)
    string << "Our beverage collection includes #{drinks_with_owners.to_sentence}."
    string.gsub!('..', '.')
    string.gsub!('a the', 'the')
    string.gsub!('a ye', 'ye')
    string
  end

  def pass_to(owner)
    if recipient = Alice::User.find_or_create(owner)
      if recipient.is_bot?
        self.message = "#{recipient.primary_nick} does not accept drinks."
      else
        self.message = "#{owner} passes the #{self.name} to #{recipient.primary_nick.capitalize}. Cheers!"
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
    self.user.primary_nick.capitalize
  end

  def spill
    self.destroy
    drop_message.gsub("the the", "the").gsub("the ye", "ye")
  end

  def drink
    self.destroy
    "#{consume_message} #{effect_message}".gsub("the the ", "the").gsub("the ye ", "ye")
  end

  def brew_message
    [
      "looks on in wonder as #{owner} brews a perfect #{self.name}.",
      "watches #{owner} whip up #{self.name}.",
      "watches #{owner} brew a nice #{self.name}.",
      "watches #{owner} brew a #{self.name}.",
      "watches as #{owner} makes a #{self.name}.",
      "watches #{owner} brew a decent #{self.name}.",
      "notices #{owner} brewing a #{self.name}.",
      "applauds as #{owner} makes a #{self.name}.",
      "nods approvingly as #{owner} brews a #{self.name}.",
      "admires #{owner}'s ability to whip up a mean #{self.name}.",
      "smiles and says, 'That's a fine #{self.name}!'",
      "admires #{owner}'s brewing prowess."
    ].sample
  end

  def effect_message
    return "" unless rand(3) == 0
    [
      "#{owner} grows bat wings and flits around the room.",
      "#{owner}'s head feel like it's deflating like a balloon. Time to get the bicycle pump!",
      "Drinking it all makes #{owner} feel a little dizzy.",
      "#{owner}'s heart grows three sizes.",
      "#{owner} achieves clarity of thought.",
      "It makes #{owner} want to contemplate the meaning of life.",
      "It really sobers up #{owner}.",
      "It makes #{owner} feel like burping.",
      "It gives #{owner} a ton of energy.",
      "It seems to drain #{owner}'s energy.",
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
      "It seems to send a shiver down #{owner}'s spine.",
      "#{owner} is filled with the sudden urge to defy gravity.",
      "#{owner} tries hard not to think of flying monkeys.",
      "#{owner} has a sudden thirst for blood.",
      "#{owner} still feels strangely parched.",
      "#{owner} feels a sudden urge to dance."
    ].sample
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
    ].sample
  end

  def consume_message
    [
      "#{owner} slams the #{self.name}.",
      "#{owner} sip the #{self.name}.",
      "#{owner} imbibes the #{self.name}.",
      "#{owner} gulps the #{self.name}.",
      "#{owner} quaffs the entire #{self.name}.",
      "#{owner} drains the #{self.name}.",
      "#{owner} consumes all of the #{self.name}."
    ].sample
  end

end

