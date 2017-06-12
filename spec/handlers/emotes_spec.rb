require 'spec_helper'

describe Handlers::Emotes do

  let(:message) {
    message = Message::Message.new("bess", "I think that was very kind")
  }

  describe "#say_something_nice" do
    it "works" do
      bess = User.find_or_create_by(primary_nick: "bess")
      handler = Handlers::Emotes.new(message: message)
      # testing random behavior is not super effective
      expect { handler.say_something_nice }.to_not raise_exception
    end
  end
end

