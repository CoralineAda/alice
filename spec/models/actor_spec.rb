require 'spec_helper'

describe Actor do

  describe "#reset_all" do

    context "actor reset" do

      let(:actor_1) { Actor.new(in_play: true, place_id: 1) }
      let(:actor_2) { Actor.new(in_play: true, place_id: 2) }
      let(:actor_3) { Actor.new(in_play: true, place_id: 3) }

      before do
        Actor.stub(:all) { [actor_1, actor_2, actor_3] }
        Actor.stub(:grue) { actor_3 }
        Actor.any_instance.stub(:save) { true }
        Actor.any_instance.stub(:put_in_play) { true }
      end

      it "sets in_play to false" do
        Actor.reset_all
        expect(actor_1.in_play).to be_false
      end

      it "clears place_id" do
        Actor.reset_all
        expect(actor_1.place_id).to be_nil
      end

      it "saves" do
        expect(actor_1).to receive(:save)
        Actor.reset_all
      end

    end

  end

end