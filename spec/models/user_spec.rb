require 'spec_helper'

describe User do

  let(:jack) { User.new(primary_nick: "jack") }
  let(:jill) { User.new(primary_nick: "jill") }
  let(:bot1) { User.new(primary_nick: "alice", is_bot: true) }

  describe ".online" do

    before do
      Adapter.stub(:user_list) { ["jack", "jill", "frederick"] }
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

  describe "#can_play_games?" do

  end

end
