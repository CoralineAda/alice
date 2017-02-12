require 'spec_helper'

describe Message::CommandString do

  let(:command) {
    Message::CommandString.new("!drop the object.")
  }

  describe "#components" do
    it "breaks its text ino an array of words" do
      expect(command.components).to eq(["drop", "the", "object"])
    end
  end

  describe "#fragment" do
    it "returns its content minus its verb" do
      expect(command.fragment).to eq("the object")
    end
  end

  describe "#verb" do
    it "selects the first component as its verb" do
      expect(command.verb).to eq("drop")
    end
  end

end
