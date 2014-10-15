require 'spec_helper'

describe Trigger do

  let(:made_trigger) {
    Trigger.new(
      verb: "made",
      synonyms: %w{make craft},
      method_name: :creator
    )
  }

  let(:craft_trigger) {
    Trigger.new(
      verb: "craft",
      synonyms: %w{made},
      method_name: :creator
    )
  }

  let(:makes_trigger) {
    Trigger.new(
      verb: "makes",
      synonyms: %w{craft},
      method_name: :creator
    )
  }

  describe "#do" do

    before do
      Trigger.stub(:where) { [makes_trigger] }
      @this_item = Item.create!(name: "thing-a-ma-bob", creator_id: 1)
    end

    it 'calls a method on the object' do
      allow(@this_item).to receive(:creator)
      Trigger.from("made").with(@this_item).do
    end

  end

  describe ".from" do
    it 'returns trigger with matching verb from a verb match' do
      Trigger.stub(:where) { [made_trigger] }
      expect(Trigger.from("made")).to eq(made_trigger)
    end
    it 'returns trigger with matching verb from a synonym match' do
      Trigger.stub(:any_in) { [makes_trigger] }
      expect(Trigger.from("craft")).to eq(makes_trigger)
    end
    it 'returns trigger with matching verb from a verb and synonym match' do
      Trigger.stub(:where) { [craft_trigger] }
      Trigger.stub(:any_in) { [makes_trigger] }
      expect(Trigger.from("made")).to eq(craft_trigger)
    end
  end
end
