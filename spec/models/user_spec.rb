require 'spec_helper'

describe User do

  let(:jack) { User.new(primary_nick: "jack") }
  let(:jill) { User.new(primary_nick: "jill") }
  let(:bot1) { User.new(primary_nick: "alice", is_bot: true) }

  describe ".online" do

    before do
      Alice::Util::Mediator.stub(:user_nicks) { ["jack", "jill", "frederick"] }
      User.stub(:any_in) { [jack, jill] }
    end

    it "returns a list of online users" do
      expect(User.online).to eq([jack, jill])
    end

  end

  describe "#accepts_gifts?" do

    before do
      jack.stub(:is_online?) { true }
      jill.stub(:is_online?) { false }
    end

    it "returns false if user is a bot" do
      expect(bot1.accepts_gifts?).to be_false
    end

    it "returns false if user is not online" do
      expect(jill.accepts_gifts?).to be_false
    end

    it "returns true for non-bot, online users" do
      expect(jack.accepts_gifts?).to be_true
    end

  end

  describe "#can_play_game?" do

    before do
      jack.stub(:last_game) { DateTime.now - 12.minute }
    end

    it "returns false if game was last played < 13 minutes ago" do
      expect(jack.can_play_game?).to be_false
    end

    it "returns true if a game was never played" do
      expect(jill.can_play_game?).to be_true
    end

  end

  describe "#current_nick" do

    before do
      Alice::Util::Mediator.stub(:user_nicks) { ["jack_", "jill", "frederick"] }
      jack.stub(:nicks) { ["jack", "jack_"] }
    end

    it "matches nicks to user list nicks" do
      expect(jack.current_nick).to eq("jack_")
    end

  end

  describe "#filter_applied_date" do

    it "returns #filter_applied if it exists" do
      now = DateTime.now
      jack.filter_applied = now
      jack.filter_applied_date.should == now
    end

    it "returns yesterday if filter_applied is nil" do
      now = DateTime.now
      DateTime.stub(:now) { now }
      jack.filter_applied = nil
      jack.filter_applied_date.should eq(now - 1.day)
    end

  end

  describe "#has_nick?" do

    before do
      jill.alt_nicks = ["jilla", "jilly"]
    end

    it "finds based on primary nick" do
      expect(jill.has_nick?("jill")).to be_true
    end

    it "finds based on alt nicks" do
      expect(jill.has_nick?("jilla")).to be_true
    end

  end

  describe "#remove_filter?" do

    it "returns true if the last filter was applied more than 90 minutes ago" do
      jack.filter_applied = DateTime.now - 91.minutes
      expect(jack.remove_expired_filters).to be_true
    end

    it "returns false if the last filter was applied within the last 90 minutes" do
      jack.filter_applied = DateTime.now - 11.minutes
      expect(jack.remove_expired_filters).to be_false
    end

  end

  describe "#update_nick" do

    before do
      jill.alt_nicks = ["jilla", "jilly"]
    end

    it "does not duplicate a nick" do
      jill.should_not_receive(:update_attribute)
      jill.update_nick("jilly")
    end

    it "adds a new nick" do
      jill.should_receive(:update_attribute).with(:alt_nicks, ["jilla", "jilly", "nancy"])
      jill.update_nick("Nancy")
    end

  end

end
