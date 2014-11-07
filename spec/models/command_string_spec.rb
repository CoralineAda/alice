require 'spec_helper'

describe CommandString do

  let(:command) {
    CommandString.new("!drop the object.")
  }
  let(:predicate_command) {
    CommandString.new("!give the relic to Indie.")
  }
  let(:alt_predicate_command) {
    CommandString.new("!take the gold from the rich!")
  }

  describe "#components" do
    it "breaks its text ino an array of words" do
      expect(command.components).to eq(["drop", "the", "object"])
    end
  end

  describe "#verb" do
    it "selects the first component as its verb" do
      expect(command.verb).to eq("drop")
    end
  end

  describe "#subject" do

    context "without predicate" do
      it "returns the subject" do
        expect(command.subject).to eq("the object")
      end
    end

    context "with predicate" do
      it "returns the subject" do
        expect(predicate_command.subject).to eq("the relic")
      end
    end

  end

  describe "#has_predicate?" do
    it "detects a predicate" do
      expect(predicate_command.has_predicate?).to be_true
    end
    it "returns false if no predicate" do
      expect(command.has_predicate?).to be_false
    end
  end

  describe "#predicate" do
    it "extracts its 'to' predicate" do
      expect(predicate_command.predicate).to eq("Indie")
    end
    it "extracts its 'from' predicate" do
      expect(alt_predicate_command.predicate).to eq("the rich")
    end
  end

end