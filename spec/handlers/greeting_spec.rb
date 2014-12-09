require 'spec_helper'

describe "Handlers::Greeting" do

  let(:user)    { User.new(primary_nick: "cflipse") }
  let(:message) { Message::Message.new(user.primary_nick, "joined the channel") }
  let(:handler) { Handlers::Greeting.new(message: message) }

  before do
    message.stub(:sender_nick) { user.primary_nick }
    handler.stub(:subject) { user }
    Pipeline::Mediator.stub(:exists?) { true }
  end

  describe "#greet_sender" do
    it "is wired to a working method" do
      expect(::Greeting.respond_to?(:greet)).to be_truthy
    end
    it "calls the correct method" do
      expect(::Greeting).to receive(:greet)
      handler.greet_sender
    end
  end

end