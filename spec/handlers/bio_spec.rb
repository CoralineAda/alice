require 'spec_helper'

describe "Handlers::Bio" do

  let(:user)      { User.new(primary_nick: "Sindarina") }
  let(:message_1) { Message::Message.new(user.primary_nick, "\"is a star\"") }
  let(:message_2) { Message::Message.new(user.primary_nick, "") }
  let(:handler_1) { Handlers::Bio.new(message: message_1) }
  let(:handler_2) { Handlers::Bio.new(message: message_2) }

  before do
   message_1.stub(:sender) { user }
   handler_1.stub(:subject) { user }
   message_2.stub(:sender) { user }
   handler_2.stub(:subject) { user }
  end

  describe "#process" do

    context "quoted text" do
      it "calls update_bio" do
        expect(user).to receive(:update_bio)
        handler_1.process
      end
    end

    context "no quoted text" do
      it "calls formatted_bio" do
        expect(user).to receive(:formatted_bio)
        handler_2.process
      end
    end

  end

end