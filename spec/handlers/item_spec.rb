require 'spec_helper'

describe "Item" do

  describe "#destroy" do

    let(:user)    { User.new(primary_nick: "Lydia") }
    let(:item)    { user.items.new(name: "Book") }
    let(:message) { Message.new(user.primary_nick, "destroy book") }
    let(:handler) { Handlers::Item.new(message: message) }

    before do
      handler.stub(:item_for_user) { item }
    end

    it "calls item descruct" do
      expect(item).to receive(:destruct)
      handler.destroy
    end

  end

  describe "#drop"

  describe "#examine"

  describe "#find"

  describe "#forge"

  describe "#give"

  describe "#hide"

  describe "#play"

  describe "#read"

  describe "#steal"

end