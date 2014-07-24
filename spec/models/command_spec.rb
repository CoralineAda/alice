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

  describe "#meets_odds?" do

    let(:times) { 1000 }

    it "always meets odds if its odds are 1 in 1" do
      command = Command.new(one_in_x_odds: 1)
      results = (1..times).to_a.inject([]){ |a, i| a << (command.meets_odds? ? 1 : nil); a}.compact
      expect(results.count).to eq times
    end

    it "sometimes meets odds" do
      command = Command.new(one_in_x_odds: 2)
      results = (1..times).to_a.inject([]){ |a, i| a << (command.meets_odds? ? 1 : nil); a}.compact
      expect(results.count > 0).to be_true
    end

    it "doesn't always meet odds" do
      command = Command.new(one_in_x_odds: 2)
      results = (1..times).to_a.inject([]){ |a, i| a << (command.meets_odds? ? 1 : nil); a}.compact
      expect(results.count < times).to be_true
    end

  end

  describe "#needs_cooldown?" do

    let(:command) { Command.new }

    it "returns false if the command was never triggered before" do
      command.stub(:last_said_at) { nil }
      expect(command.needs_cooldown?).to be_false
    end

    it "returns false if there is no cooldown set" do
      command.stub(:last_said_at) { Time.now }
      command.stub(:cooldown_minutes) { 0 }
      expect(command.needs_cooldown?).to be_false
    end

    it "returns false if the cooldown period has passed" do
      command.stub(:last_said_at) { Time.now - 10.minutes }
      command.stub(:cooldown_minutes) { 9 }
      expect(command.needs_cooldown?).to be_false
    end

    it "returns true if the cooldown period has not passed" do
      command.stub(:last_said_at) { Time.now - 5.minutes }
      command.stub(:cooldown_minutes) { 9 }
      expect(command.needs_cooldown?).to be_true
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