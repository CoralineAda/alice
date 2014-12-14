require 'spec_helper'

describe Context do

  describe "::current" do

    before do
      allow_any_instance_of(Context).to receive(:define_corpus) { true }
      allow_any_instance_of(Context).to receive(:extract_keywords) { true }
      allow_any_instance_of(Context).to receive(:fetch_content_from_sources) { "" }
      @context_1 = Context.create(
        topic: "black rider",
        is_current: true,
        keywords: [],
        expires_at: Time.now + 30.minutes
      )
      @context_2 = Context.create(
        topic: "coach and four",
        is_current: true,
        keywords: [],
        expires_at: Time.now - 5.minutes
      )
    end

    it "selects the most current context" do
      expect(Context.current).to eq(@context_1)
    end
  end

  context "user context" do

    before do
      allow_any_instance_of(Context).to receive(:extract_keywords) { true }
      allow(Parser::Wikipedia).to receive(:fetch) { "" }
      allow(Parser::Google).to receive(:fetch) { "" }

      @user = User.create!(
        primary_nick: "NickCave",
        twitter_handle: "@NickCave",
        filter_applied: "drunk",
        points: 11,
        last_theft: Date.today - 1.day
      )
      Bio.create(user: @user, text: "is a musician, songwriter, author, screenwriter, composer and occasional film actor.")
      @user.factoids.create(text: "Nick Cave was born on September 22, 1957.")
      @user.factoids.create(text: "He is Australian")
      @user.factoids.create(text: "Cave used to front the band The Birthday Party.")
      @user.factoids.create(text: "He had a music project called Grinderman, which was awful.")
      @context = Context.create(topic: "NickCave")
    end

    context "derives a corpus from user data" do
      it "including factoids" do
        expect(@context.corpus.include?("He is Australian")).to be_truthy
      end

      it "including bio" do
        expected = "Nickcave is a musician, songwriter, author, screenwriter, composer and occasional film actor"
        p @context.corpus
        p expected

        expect(@context.corpus.include?(expected)).to be_truthy
      end

      it "including attributes" do
        expect(@context.corpus.include?("Nickcave is on Twitter as @NickCave")).to be_truthy
      end
    end

  end

  describe "::keywords_from" do
    it "extracts keywords from a topic" do
      result = Context.keywords_from("tables chairs accessories")
      expect(result).to match_array(["tables", "chairs", "accessories"])
    end

    it "removes predicate indicators" do
      result = Context.keywords_from("beneath her coat there are wings")
      expect(result).to match_array(["beneath", "her", "coat", "there", "wings"])
    end
  end

  describe "::with_topic_matching" do
    before do
      allow_any_instance_of(Context).to receive(:define_corpus) { true }
      allow_any_instance_of(Context).to receive(:extract_keywords) { true }
      allow_any_instance_of(Context).to receive(:fetch_content_from_sources) { "" }
      @context_1 = Context.create(topic: "black rider", keywords: ["black", "wings"])
    end

    it "returns an exact topic match" do
      expect(Context.with_topic_matching("black rider")).to eq(@context_1)
    end
    it "returns a topic match without articles" do
      expect(Context.with_topic_matching("the black rider")).to eq(@context_1)
    end
  end

  describe "::with_keywords_matching" do
    before do
      allow_any_instance_of(Context).to receive(:define_corpus) { true }
      allow_any_instance_of(Context).to receive(:extract_keywords) { true }
      allow_any_instance_of(Context).to receive(:fetch_content_from_sources) { "" }
      @context_1 = Context.create(topic: "black rider", keywords: ["bleached", "bones"])
      @context_2 = Context.create(topic: "coach and four", keywords: ["white", "bleached", "bones"])
    end

    it "picks the strongest keyword correlation" do
      expect(Context.with_keywords_matching("bleached white bones")).to eq(@context_2)
    end
  end

  describe ".ambiguous?" do
    it "detects an ambiguous context" do
      @context = Context.new(corpus:
        [
          "Death may refer to the hooded grim reaper or a brand of cigarettes.",
          "Death is inevitable and unescapable."
        ]
      )
      expect(@context.ambiguous?).to be_truthy
    end
  end

  describe ".expire" do
    it "expires the context if its expires_at has passed" do
      expect_any_instance_of(Context).to receive(:expire!)
      Context.new(expires_at: Time.now - 1.minute).expire
    end

    it "does not expire the context if its expires_at is in the future" do
      expect(Context.new(expires_at: Time.now + 1.minute).expire).to be_falsey
    end
  end

  describe ".describe" do
    before do
      @context = Context.new(topic: "tom waits", corpus:
        [
          "Tom Waits is an intriguing figure.",
          "Black Rider was an amazing accomplishment for Tom Waits.",
          "All the world should know who Tom Waits is."
        ]
      )
      allow(@context).to receive(:record_spoken) { true }
    end

    it "selects a fact most closely resembling a definition" do
      expect(@context.describe).to eq("Tom Waits is an intriguing figure.")
    end
  end

  describe ".define_corpus" do

    before do
      context = Context.new
      allow(context).to receive(:fetch_content_from_sources) {
        [
          "Tom Waits may refer to whatever.",
          "He is amazing.",
          "Waits' lyrics frequently present <em>atmospheric portraits</em> of grotesque, often seedy characters and places—although he has also shown a penchant for more conventional ballads.",
          "He has a cult following and has influenced subsequent songwriters despite having little radio or music video support.",
          "Although Waits' albums have met with mixed commercial success in his native United States, they have occasionally achieved gold album sales status in other countries.",
          "He has been nominated for a number of major music awards and has won Grammy Awards for two albums, Bone Machine and Mule Variations.",
          "In 2011, Waits was inducted into the Rock and Roll Hall of Fame.[3][4]"
        ].join("\n")
      }
      context.define_corpus
      @corpus = context.corpus
    end

    it "rejects short sentences" do
      expect(@corpus.include?("He is amazing.")).to be_falsey
    end

    it "rejects disambiguation sentences" do
      expect(@corpus.include?("Tom Waits may refer to whatever.")).to be_falsey
    end
  end

  describe ".extract_keywords" do

    let(:context) { Context.new }
    let(:corpus) {
      [
        "the fox and the dog",
        "the quick brown fox",
        "ran into trouble with",
        "the dish and the spoon are in love",
        "the dish ran away with the spoon."
      ]
    }

    before do
      allow(context).to receive(:corpus) { corpus }
    end

    it "finds and returns a list of high-frequency probable nouns" do
      context.send(:extract_keywords)
      expect(context.keywords).to match_array(
        ["fox", "dish", "spoon", "ran"]
      )
    end

    describe ".facts" do
      let(:context) { Context.new }
      let(:corpus) {
        [
          "the fox and the dog",
          "the quick brown fox",
          "ran into trouble with",
          "the dish and the spoon are in love",
          "the dish ran away with the spoon.",
          "the spoon is shiny",
          "the dish, definitely not what it is"
        ]
      }

      before do
        allow(context).to receive(:corpus) { corpus }
      end

      it "favors a sentence with an early instance of is/was" do
        expect(context.facts.first).to eq("the spoon is shiny")
      end
    end

  end

end