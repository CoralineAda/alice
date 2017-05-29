require 'spec_helper'

describe Handlers::Bio do

  let(:message) {
    message = Message::Message.new("bess", "!bio Hi! I'm Bess! I live in DC. :heart:")
  }

  describe "#process" do

    it "sets the bio as specified" do
      bess = User.find_or_create_by(primary_nick: "bess")
      handler = Handlers::Bio.new(message: message)
      handler.process
      expect(bess.reload.bio.text).to eq("Hi! I'm Bess! I live in DC. :heart:")
    end

  end

end
