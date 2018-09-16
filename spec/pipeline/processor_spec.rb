require 'spec_helper'

describe Pipeline::Processor do

  let(:processor) { Pipeline::Processor.new }
  let(:bang)      { "!look" }
  let(:number)    { "20 20 24 hours to go" }
  let(:plusplus)  { "@daniel++" }
  let(:cplusplus) { "C++" }
  let(:alice)     { "Alice, say hello" }
  let(:nice)      { "That sounds nice!" }
  let(:ignore)    { "Bass is hard." }

  describe ".should_respond" do

    it "responds to bang messages" do
      processor.trigger = bang
      expect(processor.should_respond?).to be_truthy
    end

    it "responds to number messages" do
      processor.trigger = number
      expect(processor.should_respond?).to be_truthy
    end

    it "responds to foo++ messages" do
      processor.trigger = plusplus
      expect(processor.should_respond?).to be_truthy
    end

    it "does not respond to C++" do
      processor.trigger = cplusplus
      expect(processor.should_respond?).to be_falsey
    end

    it "responds to Alice messages" do
      processor.trigger = alice
      expect(processor.should_respond?).to be_truthy
    end

    it "responds to nice messages" do
      processor.trigger = nice
      expect(processor.should_respond?).to be_truthy
    end

    it "ignores all other messages" do
      processor.trigger = ignore
      expect(processor.should_respond?).to be_falsey
    end

  end

end
