require 'spec_helper'

describe Item do

  describe "#creator" do

    let(:item_1) { Item.new(creator_id: 5) }
    let(:item_2) { Item.new(creator_id: nil) }
    let(:existing_user) { User.new(id: 5) }

    it "returns its creator user" do
      allow(User).to receive(:find) { existing_user }
      expect(item_1.creator).to eq(existing_user)
    end

    it "defaults to a blank user" do
      expect(item_2.creator.primary_nick).to eq("Aunt Trudy")
    end

  end

end
