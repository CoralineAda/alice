require 'spec_helper'

describe Alice::Listener do

  class Message
    include PoroPlus
    attr_accessor :raw
    def user; Struct.new(:nick); end
  end

  before do
    Alice::Listener.any_instance.stub(:track) { true }
  end

  context "#parse_command" do

    let(:bot) { Alice::Bot.new.bot }
    let(:listener) { Alice::Listener.new(bot) }
    let(:message) { Message.new(raw: "!help crow to fly")}

    it "sets its message" do
      listener.stub(:respond)
      listener.parse_command(message, message.raw)
      expect(listener.message).to eq message
    end

    it "sets its params" do
      listener.stub(:respond)
      listener.parse_command(message, message.raw)
      expect(listener.param).to eq "!help crow to fly"
    end

  end

  context "command recognition" do

    let(:bot) { Alice::Bot.new.bot }
    let(:listener) { Alice::Listener.new(bot) }

    it "recognizes a direct command" do
      listener.param = "!help crow to fly"
      Alice::DirectCommand.should_receive(:process)
      listener.direct_command
    end

    it "recognizes a fuzzy command" do
      listener.param = "Alice, please help the crow to fly"
      Alice::FuzzyCommand.should_receive(:process)
      listener.fuzzy_command
    end

  end

  context "#response" do

    let(:bot) { Alice::Bot.new.bot }
    let(:listener) { Alice::Listener.new(bot) }
    let(:command) { Struct.new(:process)}

    before do
      listener.param = ""
    end

    it "processes a direct command" do
      listener.stub(:direct_command) { command }
      listener.stub(:fuzzy_command) { nil }
      command.should_receive(:invoke!)
      listener.response
    end

    it "processes a fuzzy command" do
      listener.stub(:direct_command) { nil }
      listener.stub(:fuzzy_command) { command }
      command.should_receive(:invoke!)
      listener.response
    end

  end

  context "#command_string" do

    let(:bot) { Alice::Bot.new.bot }
    let(:listener) { Alice::Listener.new(bot) }

    it "creates a command string from its param" do
      listener.param = "!help crow to fly"
      expect(listener.command_string.content).to eq "!help crow to fly"
    end

  end

end