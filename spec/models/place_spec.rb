require 'spec_helper'

describe Place do

  describe "#exits" do

    before do
      Place.delete_all
      Door.delete_all
    end

    context "matches exits between rooms" do

      before do
        @origin = Place.generate!(x: 0, y: 0)
        allow_any_instance_of(Util::Mapper).to receive(:create) { true }
      end

      it "when the neighbor is to the east" do
        neighbor = Place.generate!(x: @origin.x + 1, y: @origin.y)
        expect(neighbor.exits.include?("west")).to be_truthy
      end

      it "when the neighbor is to the west" do
        neighbor = Place.generate!(x: @origin.x - 1, y: @origin.y)
        expect(neighbor.exits.include?("east")).to be_truthy
      end

      it "when the neighbor is to the north" do
        neighbor = Place.generate!(x: @origin.x, y: @origin.y - 1)
        expect(neighbor.exits.include?("south")).to be_truthy
      end

      it "when the neighbor is to the south" do
        neighbor = Place.generate!(x: @origin, y: @origin.y + 1)
        expect(neighbor.exits.include?("north")).to be_truthy
      end

    end

  end

end
