require 'spec_helper'

describe "Message Round Trip" do

  Message::Command.delete_all

  let(:trigger_1)      { "!steal power from superman" }
  let(:trigger_2)      { "drain power from superman" }
  let(:trigger_3)      { "#{ENV['BOT_SHORT_NAME']}, steal power from superman" }
  let(:emitted_struct) { Struct.new(:user) }
  let(:sender)         { User.new(primary_nick: "Lydia", points: 2) }
  let(:emitted)        { emitted_struct.new(sender) }

  before do
    allow_any_instance_of(Pipeline::Processor).to receive(:track_sender) { true }
    allow(Util::Randomizer).to receive(:greeting) { "Hi there, Lydia." }
    allow(sender).to receive(:recently_stole?) { true }
    allow(User).to receive(:find_or_create) { sender }
    allow(Pipeline::Mediator).to receive(:emote)
    allow(Pipeline::Mediator).to receive(:reply_with)

    Message::Command.create(
      name: 'steal',
      verbs: ["steal"],
      stop_words: ["stuff"],
      handler_class: 'Handlers::Item',
      handler_method: :steal,
      response_kind: :message
    )

    Message::Command.create(
      name: "give_points",
      verbs: ["++"],
      stop_words: [ENV['BOT_SHORT_NAME'].downcase],
      indicators: [],
      handler_class: "Handlers::Points",
      handler_method: "give",
      response_kind: "message"
    )

    Message::Command.create(
      name: "youre_welcome",
      verbs: [],
      stop_words: [],
      indicators: ["thank", "thanks"],
      handler_class: "Handlers::Emotes",
      handler_method: "youre_welcome",
      response_kind: "message"
    )

    Message::Command.create(
      name: "attributes",
      verbs: ["points"],
      stop_words: [],
      indicators: [],
      handler_class: "Handlers::Properties",
      handler_method: "get_property",
      response_kind: "message"
    )
  end

  context "!command" do
    it "returns a response" do
      message = Message::Message.new(emitted.user.primary_nick, trigger_1)
      response_message = Pipeline::Processor.process(message, :respond).response
      expect(response_message.content).to eq("thinks that Lydia shouldn't press their luck on the thievery front.")
    end
  end

  context "++" do
    it "does not trigger on C++" do
      message = Message::Message.new("alva", "nice, the LLVM C API (the only stable API of LLVM, despite it being a C++ project) includes command line parsing")
      response_message = Pipeline::Processor.process(message, :respond).response
      expect(response_message.content).to eq("")
    end
  end

  context "contains bot name" do
    it "returns a response" do
      message = Message::Message.new(emitted.user.primary_nick, trigger_3)
      response_message = Pipeline::Processor.process(message, :respond).response
      expect(response_message.content).to eq("thinks that Lydia shouldn't press their luck on the thievery front.")
    end
  end

  it "says you're welcome" do
    message = Message::Message.new(emitted.user.primary_nick, "Thanks Alice")
    response_message = Pipeline::Processor.process(message, :respond).response
    expect(response_message.content).to_not be_nil
  end

  context "should not respond" do
    it "does not return a response" do
      message = Message::Message.new(emitted.user.primary_nick, trigger_2)
      response_message = Pipeline::Processor.process(message, :respond).response
      expect(response_message.content).to be_empty
    end
  end

end
