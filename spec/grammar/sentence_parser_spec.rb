require 'spec_helper'

describe "Grammar::SentenceParser" do

  it "finds a greeting" do
    sentence = "Alice, say hello to Coraline!"
    parser = Grammar::SentenceParser.new(sentence)
    parser.parse
    expect(parser.state).to eq(:greeting)
  end

  it "parses verb-subject-object" do
    sentence = "Is a bear a bear?"
    parser = Grammar::SentenceParser.new(sentence)
    parser.parse
    parsed = parser.populated_sentence
    p parser.state
    expect(parsed.info_verb).to eq("is")
    expect(parsed.subject).to eq("bear")
    expect(parsed.object).to eq("bear")
  end

  xit "" do
    sentence = "Eric is a viking"
  end

  xit "" do
    sentence = "The cat is fat."
  end

  xit "" do
    sentence = "A cat eats salmon."
  end

  xit "" do
    sentence = "Jamie doesn't care that the camera is there"
  end

end
