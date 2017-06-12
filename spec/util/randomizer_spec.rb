require 'spec_helper'

describe Util::Randomizer do
  describe "#kindness" do
    it "uses a given pronoun for a message" do
      pronoun = "she"
      100.times do
        result = Util::Randomizer.kindness('someone','she')
        expect(result).to_not match(/they/)
      end
    end
  end
end
