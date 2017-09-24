require 'spec_helper'

describe User do

  let(:jack) { User.new(primary_nick: "jack") }
  let(:jill) { User.new(primary_nick: "jill") }
  let(:bot1) { User.new(primary_nick: "alice", is_bot: true) }

  describe "#accepts_gifts?" do

    before do
      allow(jack).to receive(:is_online?) { true }
      allow(jill).to receive(:is_online?) { false }
    end

    it "returns false if user is a bot" do
      expect(bot1.accepts_gifts?).to be_falsey
    end

    it "returns false if user is not online" do
      expect(jill.accepts_gifts?).to be_falsey
    end

    it "returns true for non-bot, online users" do
      expect(jack.accepts_gifts?).to be_truthy
    end

  end

  describe "#can_play_games?" do

    before do
      allow(jack).to receive(:last_game) { DateTime.now - 12.minute }
    end

    it "returns false if game was last played < 13 minutes ago" do
      expect(jack.can_play_games?).to be_falsey
    end

    it "returns true if a game was never played" do
      expect(jill.can_play_games?).to be_truthy
    end

  end

  describe "#filter_applied_date" do

    it "returns #filter_applied if it exists" do
      now = DateTime.now
      jack.filter_applied = now
      expect(jack.filter_applied_date).to eq(now)
    end

  end

  describe "#remove_filter?" do

    it "returns true if the last filter was applied more than 90 minutes ago" do
      jack.filter_applied = DateTime.now - 91.minutes
      expect(jack.remove_expired_filters).to be_truthy
    end

    it "returns false if the last filter was applied within the last 90 minutes" do
      jack.filter_applied = DateTime.now - 11.minutes
      expect(jack.remove_expired_filters).to be_falsey
    end

  end

end
