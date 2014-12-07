require 'spec_helper'

describe "Handlers::Actor" do

  let(:user)    { User.new(primary_nick: "fivetanley") }
  let(:message) { Message.new(user.primary_nick, "!talk Poe") }
  let(:handler) { Handlers::Actor.new(message: message) }
  let(:actor)   { Actor.create!(name: "Poe") }
  before do
    message.stub(:sender)  { user }
    handler.stub(:subject) { actor }
  end

  describe "#talk" do
    it "is wired to a working method" do
      expect(actor.respond_to?(:speak)).to be_true
    end
    it "calls the correct method" do
      expect(actor).to receive(:speak)
      handler.talk
    end
  end

end