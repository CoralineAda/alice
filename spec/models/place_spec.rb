require 'spec_helper'

describe Place do

  it "matches exits between rooms" do
    origin = Place.new(x: 0, y: 0)
    origin.exits = ["east"]

    Mapper.any_instance.stub(:create) { true }
    Place.any_instance.stub(:save) { true }
    Place.stub(:random_description) { true }

    how_many = 100

    matches = how_many.times.map do
      place = Place.generate!(x: 1, y: 0)
      place.exits.include?('west') || nil
    end.compact

    expect(matches.count).to eq(how_many)

  end

end