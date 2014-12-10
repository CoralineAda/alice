require 'spec_helper'

describe "Handlers::Bio" do

  let(:user_1)    { User.create(primary_nick: "Sindarina") }
  let(:user_2)    { User.create(primary_nick: "Wuest") }
  let(:message_1) { Message::Message.new(user_1.primary_nick, "\"is a star\"") }
  let(:message_2) { Message::Message.new(user_1.primary_nick, "who is wuest?") }
  let(:message_3) { Message::Message.new(user_1.primary_nick, "who is magenta?") }
  let(:handler_1) { Handlers::Bio.new(message: message_1) }
  let(:handler_2) { Handlers::Bio.new(message: message_2) }
  let(:handler_3) { Handlers::Bio.new(message: message_3) }

  before do
   allow(message_1).to receive(:sender)      { user_1 }
   allow(message_2).to receive(:sender)      { user_1 }
   allow(User).to receive(:from)             { user_2 }
   allow(user_2).to receive(:formatted_bio)  { "full of awesomesauce" }
  end

  describe "#process" do

    context "quoted text" do
      it "calls update_bio" do
        expect(user_1).to receive(:update_bio)
        handler_1.process
      end
    end

    context "no quoted text" do
      it "calls formatted_bio" do
        expect(user_2).to receive(:formatted_bio)
        handler_2.process
      end
    end

    context "no nick specified" do
      it "calls formatted_bio" do
        expect(user_1).to_not receive(:formatted_bio)
        handler_3.process
      end
    end

  end

end