# TODO: "Alice, please tell me about a beer called Old Rasputin."

class Beer

  include PoroPlus

  attr_accessor :name, :full_name

  def self.random
    beer = new
    beer.result = beer.brewery_db.beers.random
    beer
  end

  def self.search(name)
    new(name: name)
  end

  def abv
    return unless result.abv
    sprintf("%0.1f%", result.abv.to_f) + " alcohol."
  end

  def availability
    result && result.available && result.available.description
  end

  def brewery_db
    @brewery_db ||= BreweryDB::Client.new{ |config| config.api_key = ENV['BREWERY_DB_TOKEN'] }
  end

  def brewery
    result && result.breweries && "Brewed by #{result.breweries.first.name}."
  end

  def canonical_name
    result && result.name
  end

  def container
    result && result.glass && result.glass.name || "Glass"
  end

  def name
    @name ||= beer.name
  end

  def description
    return unless result
    text = []
    text << result.description.to_s.gsub("\n", " ").gsub(/[ ]+/, " ")
    text << brewery
    text << availability
    text << pairing
    text << abv
    text << serving_temperature
    text.compact.join('. ').gsub('..', '.')
  end

  def serving_temperature
    result.serving_temperature && "Serve #{result.serving_temperature}."
  end

  def pairing
    result.food_pairings && "Goes well with: #{result.food_pairings}"
  end

  def result
    @result ||= brewery_db.search.beers(q: self.name, withBreweries: 'Y').take(1).first
  end

end
