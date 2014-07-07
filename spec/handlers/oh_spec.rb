require 'spec_helper'

describe "Handlers::OH" do

  let(:user)    { User.new(primary_nick: "brycek") }
  let(:message) { Message.new(user.primary_nick, "are you recording this?") }
  let(:handler) { Handlers::OH.new(message: message) }

  before do
   message.stub(:sender) { user }
  end

  describe "#set" do
    it "is wired to a working method" do
      expect(::OH.respond_to?(:from)).to be_true
    end
    it "calls the correct method" do
      expect(::OH).to receive(:from)
      handler.set
    end
  end

  describe "#get" do
    it "is wired to a working method" do
      expect(::OH.respond_to?(:sample)).to be_true
    end
    it "calls the correct method" do
      expect(::OH).to receive(:sample) { ::OH.new }
      handler.get
    end
  end

end