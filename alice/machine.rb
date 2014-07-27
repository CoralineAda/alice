class Machine

  include Mongoid::Document
  include Alice::Behavior::Searchable
  include Alice::Behavior::Placeable

  field :name
  field :description
  field :creation_class
  field :creation_params, type: Hash, default: {}

  validates_presence_of :name
  validates_uniqueness_of :name

  store_in collection: "alice_machines"

  belongs_to :place
  has_many :actions

  attr_accessor :just_made, :triggered_action

  def self.catalog
    "The following machines are available to !install: #{Machine.all.map(&:name).to_sentence}."
  end

  def self.sweep
    all.map{|i| i.place = nil; i.save}
  end

  def describe
    self.description
  end

  def install(installer="A friend")
    self.place = Place.current
    self.save
    return "#{installer} installs a shiny new #{self.name}!"
  end

  def name_with_article
    Alice::Util::Sanitizer.process("#{Alice::Util::Randomizer.article} #{self.name}")
  end

  def use(trigger=nil)
    triggered = self.actions.triggered_by(trigger).first
    triggered ||= self.actions.primary
    self.triggered_action = triggered
    description = do_this
    description.gsub!("<<machine_name>>", self.name_with_article)
    description.gsub!("<<thing_name>>", self.just_made.name) if self.just_made.present?
    description
  end

  private

  def do_this
    if klass.respond_to?(self.triggered_action.trigger_method)
      klass.send(self.triggered_action.trigger_method)
    else
      self.send(triggered_action.trigger_method) if triggered_action.trigger_method.present?
    end
    triggered_action.description
  end

  def klass
    class_eval(self.creation_class)
  end

  def make
    thing = klass.new(creation_params)
    thing.name = thing.randomize_name
    thing.save
    self.just_made = thing
    Place.current.items << thing if thing.is_a? Item
    Place.current.beverages << thing if thing.is_a? Beverage
  end

end