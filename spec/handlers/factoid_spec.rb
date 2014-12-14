require 'spec_helper'

describe "Handlers::Factoid" do

  let(:user)    { User.new(primary_nick: "zspenser") }
  let(:message) { Message::Message.new(user.primary_nick, "once found a bug") }
  let(:handler) { Handlers::Factoid.new(message: message) }

  before do
    allow(message).to receive(:sender) { user }
    allow(handler).to receive(:subject) { user }
    allow_any_instance_of(Context).to receive(:define_corpus) { true }
    allow_any_instance_of(Context).to receive(:extract_keywords) { true }
    allow_any_instance_of(Context).to receive(:fetch_content_from_sources) { "" }
  end

  describe "#set" do
    it "is wired to a working method" do
      expect(user.respond_to?(:set_factoid)).to be_truthy
    end
    it "calls the correct method" do
      expect(user).to receive(:set_factoid)
      handler.set
    end
  end

  describe "#get" do
    it "calls the correct method" do
      expect(Factoid).to receive(:about) { ::Factoid.new }
      handler.get
    end
  end

end