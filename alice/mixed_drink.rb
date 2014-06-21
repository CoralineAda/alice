# TODO: Alice, what is a moscow mule?

class MixedDrink

  include PoroPlus

  attr_accessor :name, :ingredients, :flavors

  def self.search(name)
    result = Yummly.search(name, maxResult: 1, allowedCourse: "course^course-Cocktails").first
    drink = new(
      name: result.name,
      ingredients: result.ingredients,
      flavors: result.json['flavors']
    )
  end

  def description
    text = []
    text << "A #{flavor} concoction." if flavor
    text << "Made from #{ingredients.to_sentence}."
    text.compact.join(" ")
  end

  def flavor
    return unless self.flavors.present?
    self.flavors.select{|k,v| v > 0}.keys.to_sentence
  end

end