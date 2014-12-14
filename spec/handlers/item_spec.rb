require 'spec_helper'

describe "Handlers::Item" do

  let(:user)    { User.new(primary_nick: "Lydia") }
  let(:item)    { user.items.new(name: "Book") }
  let(:message) { Message::Message.new(user.primary_nick, "destroy book") }
  let(:handler) { Handlers::Item.new(message: message) }

  before do
    allow(handler).to receive(:item) { item }
    allow(handler).to receive(:item_for_user) { item }
    allow(handler).to receive(:loose_item) { item }
    allow(message).to receive(:sender) { user }
  end

  describe "#destroy" do
    it "is wired to a working method" do
      expect(item.respond_to?(:destruct)).to be_truthy
    end
    it "calls item destruct" do
      expect(item).to receive(:destruct)
      handler.destroy
    end
  end

  describe "#drop" do
    it "is wired to a working method" do
      expect(item.respond_to?(:drop)).to be_truthy
    end
    it "calls item drop" do
      expect(item).to receive(:drop)
      handler.drop
    end
  end

  describe "#forge" do
    it "is wired to a working method" do
      expect(::Item.respond_to?(:forge)).to be_truthy
    end
    it "calls forge" do
      expect(::Item).to receive(:forge)
      handler.forge
    end
  end

  describe "#give" do

    let(:recipient) { User.new(primary_nick: "Bob") }
    before do
      allow(User).to receive(:from) { recipient }
      allow(recipient).to receive(:accepts_gifts?) { true }
    end
    it "is wired to a working method" do
      expect(item.respond_to?(:transfer_to)).to be_truthy
    end
    it "calls item transer_to" do
      expect(item).to receive(:transfer_to)
      handler.give
    end
  end

  describe "#hide"

  describe "#play" do
    it "is wired to a working method" do
      expect(item.respond_to?(:play)).to be_truthy
    end
    it "calls item play" do
      expect(item).to receive(:play)
      handler.play
    end
  end

  describe "#read" do
    it "is wired to a working method" do
      expect(item.respond_to?(:read)).to be_truthy
    end
    it "calls item read" do
      expect(item).to receive(:read)
      handler.read
    end
  end

  describe "#steal" do
    it "is wired to a working method" do
      expect(user.respond_to?(:steal)).to be_truthy
    end
    it "calls item transer_to" do
      expect(user).to receive(:steal)
      handler.steal
    end
  end

end