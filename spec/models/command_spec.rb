require 'spec_helper'

describe Message::Command do

  describe "#meets_odds?" do

    let(:times) { 1000 }

    it "always meets odds if its odds are 1 in 1" do
      command = Message::Command.new(one_in_x_odds: 1)
      results = (1..times).to_a.inject([]){ |a, i| a << (command.meets_odds? ? 1 : nil); a}.compact
      expect(results.count).to eq times
    end

    it "sometimes meets odds" do
      command = Message::Command.new(one_in_x_odds: 2)
      results = (1..times).to_a.inject([]){ |a, i| a << (command.meets_odds? ? 1 : nil); a}.compact
      expect(results.count > 0).to be_truthy
    end

    it "doesn't always meet odds" do
      command = Message::Command.new(one_in_x_odds: 2)
      results = (1..times).to_a.inject([]){ |a, i| a << (command.meets_odds? ? 1 : nil); a}.compact
      expect(results.count < times).to be_truthy
    end

  end

  describe "#needs_cooldown?" do

    let(:command) { Message::Command.new }

    it "returns false if the command was never triggered before" do
      allow(command).to receive(:last_said_at) { nil }
      expect(command.needs_cooldown?).to be_falsey
    end

    it "returns false if there is no cooldown set" do
      allow(command).to receive(:last_said_at) { Time.now }
      allow(command).to receive(:cooldown_minutes) { 0 }
      expect(command.needs_cooldown?).to be_falsey
    end

    it "returns false if the cooldown period has passed" do
      allow(command).to receive(:last_said_at) { Time.now - 10.minutes }
      allow(command).to receive(:cooldown_minutes) { 9 }
      expect(command.needs_cooldown?).to be_falsey
    end

    it "returns true if the cooldown period has not passed" do
      allow(command).to receive(:last_said_at) { Time.now - 5.minutes }
      allow(command).to receive(:cooldown_minutes) { 9 }
      expect(command.needs_cooldown?).to be_truthy
    end

  end

end
