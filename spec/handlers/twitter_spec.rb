require 'spec_helper'

describe "Handlers::Twitter" do

  let(:user)    { User.new(primary_nick: "computionist") }
  let(:message) { Message.new(user.primary_nick, "@computionist") }
  let(:handler) { Handlers::Twitter.new(message: message) }

  before do
   message.stub(:sender) { user }
   handler.stub(:subject) { user }
  end

  describe "#set" do
    it "is wired to a working method" do
      expect(user.respond_to?(:set_twitter_handle)).to be_truthy
    end
    it "calls the correct method" do
      expect(user).to receive(:set_twitter_handle)
      handler.set
    end
  end

  describe "#get" do
    it "is wired to a working method" do
      expect(user.respond_to?(:formatted_twitter_handle)).to be_truthy
    end
    it "calls the correct method" do
      expect(user).to receive(:formatted_twitter_handle)
      handler.get
    end
  end

end