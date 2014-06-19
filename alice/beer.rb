# TODO: "Alice, please tell me about a beer called Old Rasputin."

class Beer

  include PoroPlus

  attr_accessor :name, :beer

  def self.random
    beer = new
    beer.beer = beer.brewery_db.beers.random
    beer
  end

  def self.search(name)
    beer = new
    beer.name = name
    beer.description
  end

  def brewery_db
    @brewery_db ||= BreweryDB::Client.new{ |config| config.api_key = ENV['BREWERY_DB_TOKEN'] }
  end

  def beer
    @beer ||= brewery_db.search.beers(q: self.name, withBreweries: 'Y').take(1).first
  end

  def abv
    return unless beer.abv
    sprintf("%0.1f%", beer.abv.to_f) + " alcohol."
  end

  def availability
    beer.available && beer.available.description
  end

  def brewery
    beer.breweries && "Brewed by #{beer.breweries.first.name}."
  end

  def container
    beer.glass && beer.glass.name || "Glass"
  end

  def description
    return "Hmm, a mysterious brew to be sure." unless self.beer
    text = []
    text << beer.description
    text << brewery
    text << availability
    text << pairing
    text << abv
    text << serving_temperature
    text.compact.join('. ').gsub('..', '.')
  end

  def name
    beer.name
  end

  def serving_temperature
    beer.serving_temperature && "Serve #{beer.serving_temperature}."
  end

  def pairing
    beer.food_pairings && "Goes well with: #{beer.food_pairings}"
  end

end
