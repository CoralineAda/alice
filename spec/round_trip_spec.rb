require 'spec_helper'

describe "Message Round Trip" do

  Message::Command.delete_all

  let(:trigger_1)      { "!steal power from superman" }
  let(:trigger_2)      { "drain power from superman" }
  let(:trigger_3)      { "Alice, steal power from superman" }
  let(:emitted_struct) { Struct.new(:user) }
  let(:sender)         { User.new(primary_nick: "Lydia") }
  let(:emitted)        { emitted_struct.new(sender) }
  let(:command)        { Message::Command.new(
                            name: 'steal',
                            verbs: ["steal"],
                            stop_words: ["stuff"],
                            handler_class: 'Handlers::Item',
                            handler_method: :steal,
                            response_kind: :message
                          )
                        }
  let(:channel)        { Object.new }

  before do
    Pipeline::Processor.any_instance.stub(:track_sender) { true }
    Alice::Util::Randomizer.stub(:greeting) { "Hi there, Lydia." }
    sender.stub(:recently_stole?) { true }
    User.stub(:find_or_create) { sender }
    Message::Command.stub(:any_in) { [command] }
    Alice::Util::Mediator.stub(:emote)
    Alice::Util::Mediator.stub(:reply_with)
  end

  context "!command" do
    it "returns a response" do
      message = Message::Message.new(emitted.user.primary_nick, trigger_1)
      response_message = Pipeline::Processor.process(channel, message, :respond)
      expect(response_message.response).to eq("thinks that Lydia shouldn't press their luck on the thievery front.")
    end
  end

  context "contains Alice" do
    it "returns a response" do
      message = Message::Message.new(emitted.user.primary_nick, trigger_3)
      response_message = Pipeline::Processor.process(channel, message, :respond)
      expect(response_message.response).to eq("thinks that Lydia shouldn't press their luck on the thievery front.")
    end
  end

  context "should not respond" do
    it "does not return a response" do
      message = Message::Message.new(emitted.user.primary_nick, trigger_2)
      response_message = Pipeline::Processor.process(channel, message, :respond)
      expect(response_message.response).to be_nil
    end
  end

  context "user join" do
    it "responds to a join message" do
      Alice::Util::Randomizer.stub(:one_chance_in) { true }
      message = Message::Message.new(emitted.user.primary_nick, trigger_1)
      response_message = Pipeline::Processor.process(channel, message, :greet_on_join)
      expect(response_message.response).to eq("Hi there, Lydia.")
    end
  end

end