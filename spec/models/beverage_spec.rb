require 'spec_helper'

describe Beverage do

  describe ".brew" do

    let(:user) { User.new(primary_nick: "nick_primary") }

    it "returns a singleton message if there is already a beverage with that name" do
      user.stub_chain(:beverages, :already_exists?) { true }
      expect(Beverage.brew("black coffee in bed", user)).to eq(Constants::THERE_CAN_BE_ONLY_ONE)
    end

    it "returns an encumberance message if the brewer has too much stuff" do
      user.stub(:can_brew?) { false }
      expect(Beverage.brew("black coffee in bed", user)).to eq(Constants::THATS_ENOUGH_DONTCHA_THINK)
    end

    it "creates a beverage for the user" do
      user.stub_chain(:beverages, :create) { Beverage.new }
      user.stub_chain(:beverages, :already_exists?) { false }
      user.stub(:can_brew?) { true }
      expect(Alice::Util::Randomizer).to receive(:brew_observation)
      Beverage.brew("black coffee in Moscow", user)
    end

    it "returns an error message if something breaks along the way" do
      user.stub_chain(:beverages, :create) { false }
      user.stub_chain(:beverages, :already_exists?) { false }
      user.stub(:can_brew?) { true }
      expect(Beverage.brew("black coffee in Moscow", user)).to eq(Constants::UH_OH)
    end

  end

end
