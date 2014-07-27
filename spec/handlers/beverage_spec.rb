require 'spec_helper'

describe "Handlers::Beverage" do

  let(:user)    { User.new(primary_nick: "Coraline") }
  let(:message) { Message.new(user.primary_nick, "drink coffee") }
  let(:handler) { Handlers::Beverage.new(message: message) }

  before do
   message.stub(:sender) { user }
  end

  describe "#brew" do
    it "is wired to a working method" do
      expect(::Beverage.respond_to?(:brew)).to be_true
    end
    it "calls Beverage.brew" do
      expect(::Beverage).to receive(:brew)
      handler.brew
    end
  end

  describe "#drink" do
    it "is wired to a working method" do
      expect(::Beverage.respond_to?(:consume)).to be_true
    end
    it "calls Beverage.brew" do
      expect(::Beverage).to receive(:consume)
      handler.drink
    end
  end

end