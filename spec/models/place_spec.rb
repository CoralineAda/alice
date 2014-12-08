require 'spec_helper'

describe Place do

  describe ".exits_for_neighbors" do

    before do
      Place.delete_all
      Place.any_instance.stub(:ensure_description) { true }
      @place = Place.create!(x:0, y:0, is_current: true )
      @north = Place.create!(x: 0, y: -1)
      @south = Place.create!(x: 0, y: 1)
      @east = Place.create!(x: 1, y: 0)
      @west = Place.create!(x: -1, y: 0)
    end

    it "detects its neighbors" do
      @place.neighbors.each do |neighbor|
        expect([@north, @south, @east, @west].include?(neighbor)).to be_truthy
      end
    end

  end

  describe ".generate" do

    before do
      Place.delete_all
    end

    it "matches exits between rooms" do
      origin = Place.create(x: 0, y: 0, exits: ["east"])

      Mapper.any_instance.stub(:create) { true }
      Place.any_instance.stub(:save) { true }
      Place.stub(:random_description) { true }

      how_many = 100

      matches = how_many.times.map do
        place = Place.generate!(x: 1, y: 0, is_current: true)
        value = place.exits.include?('west') || nil
        place.delete
        value
      end.compact

      expect(matches.count).to eq(how_many)
    end
  end

end