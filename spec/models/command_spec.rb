require 'spec_helper'

describe Command do

  describe ".best_match" do

    let(:command_1) { Command.new(indicators: ["quick", "brown", "fox", "jump"]) }
    let(:command_2) { Command.new(indicators: ["lazy", "dog", "jump"]) }
    let(:command_3) { Command.new(indicators: ["cow", "moon", "jump"]) }

    it "sorts by # of indicators, returning best match" do
      matches = [command_1, command_2, command_3]
      indicators = ["jump", "fox", "dog"]
      expect(Command.best_match(matches, indicators)).to eq(command_1)
    end

  end

  describe ".from" do

    let(:command_1) { Command.new(indicators: ["quick", "brown", "fox", "jump"]) }
    let(:command_2) { Command.new(indicators: ["lazy", "dog", "jump"]) }
    let(:command_3) { Command.new(indicators: ["cow", "moon", "jump"]) }
    let(:command_4) { Command.new }

    it "returns the best match amongs one or more matches" do
      Command.stub_chain(:with_indicators, :without_stopwords) {
        [command_1, command_2, command_3]
      }
      result = Command.from(Message.new("aleister", "Alice, make the cat jump over the lazy dog!"))
      expect(result).to eq(command_2)
    end

    it "defaults to a blank command if there are no matches" do
      Command.stub_chain(:with_indicators, :without_stopwords) { [] }
      Command.stub(:default) { command_4 }
      result = Command.from(Message.new("aleister", "Alice, put the coffee down and back away."))
      expect(result).to eq(command_4)
    end

  end

  describe "#terms" do

    let(:command_1) { Command.new(indicators: ["QUICK", "Brown", "fox", "jumped"]) }

    it "returns a populated TermList" do
      expect(command_1.terms.to_a).to eq(
        ["quick", "brown", "fox", "jumped", "jump"]
      )
    end

  end

  describe "#terms=" do

    let(:command) { Command.new(indicators: ["quick", "brown"])}

    it "sets its indicators to the downcased words" do
      command.terms = ["lazy", "dog"]
      expect(command.terms.to_a).to eq(["lazy", "dog", "lazi"])
    end

  end

end