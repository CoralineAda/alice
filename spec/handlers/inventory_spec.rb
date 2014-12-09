require 'spec_helper'

describe "Handlers::Inventory" do

  let(:user)    { User.new(primary_nick: "alimac") }
  let(:message) { Message::Message.new(user.primary_nick, "!inventory") }
  let(:handler) { Handlers::Inventory.new(message: message) }

  before do
   message.stub(:sender) { user }
  end

  describe "#inventory" do
    it "is wired to a working method" do
      expect(user.respond_to?(:inventory)).to be_truthy
    end
    it "calls the correct method" do
      expect(user).to receive(:inventory)
      handler.inventory
    end
  end

end