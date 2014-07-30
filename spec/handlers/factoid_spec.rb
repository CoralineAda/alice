require 'spec_helper'

describe "Handlers::Factoid" do

  let(:user)    { User.new(primary_nick: "zspenser") }
  let(:message) { Message.new(user.primary_nick, "once found a bug") }
  let(:handler) { Handlers::Factoid.new(message: message) }

  before do
   message.stub(:sender) { user }
   handler.stub(:subject) { user }
  end

  describe "#set" do
    it "is wired to a working method" do
      expect(user.respond_to?(:set_factoid)).to be_true
    end
    it "calls the correct method" do
      expect(user).to receive(:set_factoid)
      handler.set
    end
  end

  describe "#get" do
    it "calls the correct method" do
      expect(Factoid).to receive(:about) { ::Factoid.new }
      handler.get
    end
  end

end