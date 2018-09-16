require 'spec_helper'

describe "Parser::Google" do

  let(:results) {
    [
      "The latest Tweets from Coraline Ada Ehmke (@CoralineAda). Code witch. Ruby \nHero. Speaker, writer, podcaster, activist. Creator of the Contributor Covenant.",
      "Coraline Ada Ehmke. Coraline Ada Ehmke is a software developer and open source advocate based in Chicago, Illinois. She began her career as a web developer in 1994 and has worked in a variety of industries, including engineering, consulting, education, advertising, healthcare, and software development infrastructure.",
      "Coraline Ada Ehmke. Notable Rubyist, Nefarious Code Witch, And Notorious \nSocial Justice Warrior. Coraline Ada Ehmke. I am a well-known speaker, writer, ...",
      "Coraline Ada Ehmke | November 30, 2015. On June 18 of this year a friend on \nIRC expressed his frustration with tweets by a person named Elia (@elia).",
      "Code witch. Ruby Hero. Speaker, writer, activist. @CoralineAda on Twitter. - \nCoralineAda.",
      "Jul 6, 2017 ... Well-known programmer Coraline Ada Ehmke was fired from her job at GitHub \nand she had a lot to say about how, and why, she was let go.",
      "Feb 26, 2016 ... Deconstructing Coraline Ada Ehmke's “Contributor Covenant”, And Why It's \nFoolish. Recently, this happened, where the subject of this article ...",
      "May 17, 2018 ... CORALINE ADA EHMKE. Principal Engineer, Stitch Fix. Coraline Ada Ehmke is \nan open-source advocate and developer with over 20 years of ...",
      "Apr 14, 2016 ... Coraline Ada Ehmke is known for the creation of the “Contributor Covenant,” an \nSJW Code ... GITHUB hires Ehmke to work on anti-harassment.",
      "Dec 29, 2016 - 27 min - Uploaded by Trans  HackathonCoraline keynote's Trans*H4CK's first online conference with a talk on diversity in  tech and ..."
    ]
  }
  let(:parser) { Parser::Google.new("who is coraline ehmke") }

  before do
    allow(Grammar::DeclarativeSorter).to receive(:sort).and_return(results)
    allow(parser).to receive(:full_search).and_return(results[0..4])
    allow(parser).to receive(:reductivist_search).and_return(results[5..9])
  end

  describe "#sanitized_answers" do

    it "strips out newlines" do
      answer = parser.send(:sanitized_answers, [results[0]]).first
      expect(answer).to eq("The latest Tweets from Coraline Ada Ehmke (@CoralineAda). Code witch. Ruby Hero. Speaker, writer, podcaster, activist. Creator of the Contributor Covenant.")
    end

    it "splits at ellipses" do
      answer = parser.send(:sanitized_answers, [results[5]]).first
      expect(answer).to eq("Well-known programmer Coraline Ada Ehmke was fired from her job at GitHub and she had a lot to say about how, and why, she was let go.")
    end

    it "grabs a complete sentence when there are ellipses" do
      answer = parser.send(:sanitized_answers, [results[8]]).first
      expect(answer).to eq("GITHUB hires Ehmke to work on anti-harassment.")
    end

  end
end
