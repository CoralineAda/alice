require 'spec_helper'

describe Processor do

  describe "#catch" do

    let(:bot)       { Alice.bot.bot }
    let(:processor) { Processor.new(bot) }
    let(:emit)      { Struct.new(:user) }
    let(:user)      { Struct.new(:nick) }
    let(:messenger) { user.new("fred") }
    let(:emitted)   { emit.new(messenger) }
    let(:mediator)  { Mock.new }

    before do
      Alice::Util::Mediator.stub(:exists?) { true }
      processor.stub(:respond) { true }
      processor.catch(emitted, "hi there")
    end

    it "sets its nick" do
      expect(processor.nick).to eq("fred")
    end

    it "sets its message" do
      expect(processor.message).to eq("hi there")
    end

  end

end
