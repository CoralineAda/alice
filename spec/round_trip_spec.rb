require 'spec_helper'

describe "Message Round Trip" do

  Message::Command.delete_all

  let(:trigger_1)      { "!steal power from superman" }
  let(:trigger_2)      { "drain power from superman" }
  let(:trigger_3)      { "#{ENV['BOT_SHORT_NAME']}, steal power from superman" }
  let(:emitted_struct) { Struct.new(:user) }
  let(:sender)         { User.new(primary_nick: "Lydia") }
  let(:emitted)        { emitted_struct.new(sender) }
  let(:steal_command)   { Message::Command.new(
                            name: 'steal',
                            verbs: ["steal"],
                            stop_words: ["stuff"],
                            handler_class: 'Handlers::Item',
                            handler_method: :steal,
                            response_kind: :message
                          )
                       }
  let(:give_points_command) {
    Message::Command.new(
      name: "give_points",
      verbs: ["+"],
      stop_words: [ENV['BOT_SHORT_NAME'].downcase],
      indicators: [],
      handler_class: "Handlers::Points",
      handler_method: "give",
      response_kind: "message"
    )
  }

  let(:youre_welcome_command) {
    Message::Command.new(
      name: "youre_welcome",
      verbs: ["thank", "thanks"],
      stop_words: [],
      indicators: [],
      handler_class: "Handlers::Emotes",
      handler_method: "youre_welcome",
      response_kind: "message"
    )
  }
  before do
    allow_any_instance_of(Pipeline::Processor).to receive(:track_sender) { true }
    allow(Util::Randomizer).to receive(:greeting) { "Hi there, Lydia." }
    allow(sender).to receive(:recently_stole?) { true }
    allow(User).to receive(:find_or_create) { sender }
    allow(Pipeline::Mediator).to receive(:emote)
    allow(Pipeline::Mediator).to receive(:reply_with)
  end

  context "!command" do
    before do
      allow(Message::Command).to receive(:any_in) { [steal_command] }
    end
    it "returns a response" do
      message = Message::Message.new(emitted.user.primary_nick, trigger_1)
      response_message = Pipeline::Processor.process(message, :respond).response
      expect(response_message.content).to eq("thinks that Lydia shouldn't press their luck on the thievery front.")
    end
  end

  context "++" do
    before do
      allow(Message::Command).to receive(:any_in) { [give_points_command] }
    end
    it "does not trigger on C++" do
      message = Message::Message.new("alva", "nice, the LLVM C API (the only stable API of LLVM, despite it being a C++ project) includes command line parsing")
      response_message = Pipeline::Processor.process(message, :respond).response
      expect(response_message.content).to eq("")
    end
  end

  context "contains bot name" do
    before do
      allow(Message::Command).to receive(:any_in) { [steal_command] }
    end
    it "returns a response" do
      message = Message::Message.new(emitted.user.primary_nick, trigger_3)
      response_message = Pipeline::Processor.process(message, :respond).response
      expect(response_message.content).to eq("thinks that Lydia shouldn't press their luck on the thievery front.")
    end
  end

  it "says you're welcome" do
    allow(Message::Command).to receive(:any_in) { [youre_welcome_command] }
    message = Message::Message.new(emitted.user.primary_nick, "Thanks Alice")
    response_message = Pipeline::Processor.process(message, :respond).response
    expect(response_message.content).to_not be_nil
  end

  context "should not respond" do
    before do
      allow(Message::Command).to receive(:any_in) { [steal_command] }
    end
    it "does not return a response" do
      message = Message::Message.new(emitted.user.primary_nick, trigger_2)
      response_message = Pipeline::Processor.process(message, :respond).response
      expect(response_message.content).to be_empty
    end
  end

end
