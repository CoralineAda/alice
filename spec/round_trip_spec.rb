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
    allow_any_instance_of(Pipeline::Processor).to receive(:track_sender) { true }
    allow(Util::Randomizer).to receive(:greeting) { "Hi there, Lydia." }
    allow(sender).to receive(:recently_stole?) { true }
    allow(User).to receive(:find_or_create) { sender }
    allow(Message::Command).to receive(:any_in) { [command] }
    allow(Pipeline::Mediator).to receive(:emote)
    allow(Pipeline::Mediator).to receive(:reply_with)
  end

  context "!command" do
    it "returns a response" do
      message = Message::Message.new(emitted.user.primary_nick, trigger_1)
      response_message = Pipeline::Processor.process(message, :respond).response
      p response_message
      expect(response_message.content).to eq("thinks that Lydia shouldn't press their luck on the thievery front.")
    end
  end

  context "contains Alice" do
    it "returns a response" do
      message = Message::Message.new(emitted.user.primary_nick, trigger_3)
      response_message = Pipeline::Processor.process(message, :respond).response
      expect(response_message.content).to eq("thinks that Lydia shouldn't press their luck on the thievery front.")
    end
  end

  context "should not respond" do
    it "does not return a response" do
      message = Message::Message.new(emitted.user.primary_nick, trigger_2)
      response_message = Pipeline::Processor.process(message, :respond).response
      expect(response_message.content).to be_empty
    end
  end

end
