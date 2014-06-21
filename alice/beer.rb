# TODO: "Alice, please tell me about a beer called Old Rasputin."

class Beer

  include PoroPlus

  attr_accessor :name, :full_name

  def self.random
    beer = new
    beer.beer_result = beer.brewery_db.beers.random
    beer
  end

  def self.search(name)
    new(name: name)
  end

  def brewery_db
    @brewery_db ||= BreweryDB::Client.new{ |config| config.api_key = ENV['BREWERY_DB_TOKEN'] }
  end

  def beer_result
    @beer_result ||= brewery_db.search.beers(q: self.name, withBreweries: 'Y').take(1).first
  end

  def abv
    return unless beer_result.abv
    sprintf("%0.1f%", beer_result.abv.to_f) + " alcohol."
  end

  def availability
    beer_result.available && beer_result.available.description
  end

  def brewery
    beer_result.breweries && "Brewed by #{beer_result.breweries.first.name}."
  end

  def container
    beer_result.glass && beer_result.glass.name || "Glass"
  end

  def name
    @name ||= beer.name
  end

  def description
    return "Hmm, a mysterious brew to be sure." unless beer_result
    text = []
    text << beer_result.description
    text << brewery
    text << availability
    text << pairing
    text << abv
    text << serving_temperature
    text.compact.join('. ').gsub('..', '.')
  end

  def serving_temperature
    beer_result.serving_temperature && "Serve #{beer_result.serving_temperature}."
  end

  def pairing
    beer_result.food_pairings && "Goes well with: #{beer_result.food_pairings}"
  end

end
