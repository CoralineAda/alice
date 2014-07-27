require 'spec_helper'

describe Item do

  describe "#creator" do

    let(:item_1) { Item.new(creator_id: 5) }
    let(:item_2) { Item.new(creator_id: nil) }
    let(:existing_user) { User.new }
    let(:nil_user) { User.new }

    it "returns its creator user" do
      User.stub(:where) { [existing_user] }
      expect(item_1.creator).to eq(existing_user)
    end

    it "defaults to a blank user" do
      User.stub(:where) { [nil_user] }
      expect(item_2.creator).to eq(nil_user)
    end

  end

end