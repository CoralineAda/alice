# TODO: Alice, what is a moscow mule?

class MixedDrink

  include PoroPlus

  attr_accessor :name, :ingredients, :flavors

  def self.search(name)
    new(name: name)
  end

  def canonical_name
    result && result.name
  end

  def container
    "glass"
  end

  def description
    return unless result
    text = []
    text << "A #{flavor} concoction." if flavor
    text << "Made from #{ingredients.to_sentence}."
    text.compact.join(" ")
  end

  def ingredients
    result && result.ingredients
  end

  def flavor
    return unless self.flavors.present?
    self.flavors.select{|k,v| v > 0}.keys.to_sentence
  end

  def flavors
    result && result.json['flavors']
   end

  def result
    candidate = results.sort do |a,b|
      RubyFish::Hamming.distance(self.name, a.name) <=> RubyFish::Hamming.distance(self.name, b.name)
    end.first
    return unless RubyFish::Hamming.distance(candidate, self.name) <= 5
    candidate
  end

  private

  def results
    @results ||= Yummly.search(self.name, maxResult: 5, allowedCourse: "course^course-Cocktails")
  end

end