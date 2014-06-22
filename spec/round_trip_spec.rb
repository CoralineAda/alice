require 'spec_helper'

describe "Message Round Trip" do

  let(:trigger)        { "Alice, please put a stamp on this TCP/IP packet" }
  let(:emitted_struct) { Struct.new(:user) }
  let(:sender_struct)  { Struct.new(:nick) }
  let(:sender)         { sender_struct.new("Lydia") }
  let(:emitted)        { emitted_struct.new(sender) }
  let(:message)        { Message.new(emitted.user.nick, trigger) }
  let(:command)        { Command.new() }

  before do
    Processor.any_instance.stub(:track_sender) { true }
    Alice::Util::Randomizer.stub(:greeting) { "Hi there, Lydia." }
  end

  it "returns a response to a known command" do
    response_message = Processor.process(message, :respond, trigger)
    expect(response_message.response).to eq("Lydia hands the thing over to someone.")
  end


  it "responds to a join message" do
    response_message = Processor.process(message, :greet_on_join)
    expect(response_message.response).to eq("Hi there, Lydia.")
  end

  it "response to a name change message" do
    User.stub(:find_or_create) { User.new(primary_nick: "fooster") }
    response_message = Processor.process(message, :track_nick_change)
    expect(response_message.response).to eq("notes the name change.")
  end


end