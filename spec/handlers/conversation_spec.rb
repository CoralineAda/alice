require 'spec_helper'

describe Handlers::Conversation do

  let(:message) { Message::Message.new('Coraline', "What do you know about nursery rhymes?") }
  let(:handler) { Handlers::Conversation.new(message: message) }
  let(:context_1) { Context.new(topic: 'nursery rhymes', keywords: []) }
  let(:corpus_1)  {
    [
      "the dish and the spoon are in love",
      "the dish ran away with the spoon."
    ]
  }
  let(:context_2) { Context.new(topic: 'sharks', keywords: []) }
  let(:corpus_2)  {
    [
      "they have teeth!",
      "sharks eat naughty children."
    ]
  }

  before do
    allow(context_1).to receive(:corpus) { corpus_1 }
    allow(context_2).to receive(:corpus) { corpus_2 }
    allow(handler).to receive(:current_context) { context_1 }
  end

  describe ".give_context" do
    it "responds with a context" do
      handler.give_context
      expect(message.response).to end_with('nursery rhymes.')
    end
    it "responds if no context" do
      allow(handler).to receive(:current_context) { nil }
      handler.give_context
      expect(message.response).to end_with('particular.')
    end
  end

  describe "converse" do

    context "with a fact from its predicate" do
      it "derives a fact from its predicate" do
        allow(handler).to receive(:fact_from) { "rumplestiltskin" }
        handler.converse
        expect(message.response).to end_with('rumplestiltskin.')
      end
    end

    context "with no fact from its predicate" do

      it "switches context" do
        expect(handler).to receive(:set_context_from_predicate)
        allow(handler).to receive(:fact_from) { nil }
        handler.converse
      end

      it "derives a fact from the new context" do
        allow(handler).to receive(:set_context_from_predicate)
        allow(handler).to receive(:current_context).and_return(context_1, context_2 )
        allow(handler).to receive(:fact_from).and_return(nil, context_2.corpus.first)
        handler.converse
        expect(message.response).to end_with('teeth!')
      end

      context "if no fact from new context" do

        before do
          allow(handler).to receive(:context_stack) { [context_1, context_2] }
          allow(handler).to receive(:set_context_from_predicate)
          allow(handler).to receive(:fact_from).and_return(nil, nil)
        end

        it "switches back to its previous context" do
          handler.converse
          expect(handler.send(:current_context)).to eq(context_1)
        end

        it "returns a default response" do
          expect(Util::Randomizer).to receive(:i_dont_know) { "I dunno"}
          handler.converse
        end
      end

    end
  end

end