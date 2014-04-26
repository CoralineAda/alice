require 'spec_helper'

describe Alice::Listener do

  class Message
    attr_accessor :raw
    def user
      Struct.new(:nick)
    end
  end

  context "direct command" do

    let(:bot) { Alice::Bot.new.bot }
    let(:listener) { Alice::Listener.new(bot) }
    let(:message) { Message.new(raw: "!help crow to fly")}
    it "parses the command" do
      listener.parse_command(Message.new)
    end

  end

end