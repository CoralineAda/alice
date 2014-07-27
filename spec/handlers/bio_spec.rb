require 'spec_helper'

describe "Handlers::Bio" do

  let(:user)    { User.new(primary_nick: "Sindarina") }
  let(:message) { Message.new(user.primary_nick, "is a star") }
  let(:handler) { Handlers::Bio.new(message: message) }

  before do
   message.stub(:sender) { user }
   handler.stub(:subject) { user }
  end

  describe "#set" do
    it "is wired to a working method" do
      expect(user.respond_to?(:update_bio)).to be_true
    end
    it "calls update_bio" do
      expect(user).to receive(:update_bio)
      handler.set
    end
  end

  describe "#get" do
    it "is wired to a working method" do
      expect(user.respond_to?(:formatted_bio)).to be_true
    end
    it "calls formatted_bio" do
      expect(user).to receive(:formatted_bio)
      handler.get
    end
  end

end