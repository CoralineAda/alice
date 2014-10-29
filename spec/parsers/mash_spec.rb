require 'spec_helper'

describe "Alice::Parser::Mash" do

  before do
    @robyn  = User.create!(primary_nick: "robyn")
    @syd    = User.create!(primary_nick: "syd")
    @tomato = Item.create!(name: "tomato")
  end

  context "Alice, say hello to Syd" do

    let(:command_string)  { CommandString.new("Alice, say hello to Syd.") }
    let(:parser)          { Alice::Parser::Mash.new(command_string) }

    before do
      parser.parse!
    end

    it "greet Syd" do
      expect(parser.this_object).to eq(@syd)
    end

  end

  context "Alice, what do you know about Briggs?" do

    let(:command_string)  { CommandString.new("Alice, what do you know about Briggs?") }
    let(:parser)          { Alice::Parser::Mash.new(command_string) }

    before do
      parser.parse!
    end

    it "recognize topic" do
      expect(parser.this_subject).to eq('Briggs')
    end

  end

  context "Alice, please give the tomato to Robyn." do

    let(:command_string)  { CommandString.new("Alice, please give the tomato to Robyn.") }
    let(:parser)          { Alice::Parser::Mash.new(command_string) }

    before do
      parser.parse!
    end

    it "recognizes the tomato object" do
      expect(parser.this_object).to eq(@tomato)
    end

    it "recognizes the Robyn user" do
      expect(parser.this_subject).to eq(@robyn)
    end

  end

  context "Alice, please give Robyn the tomato." do

    let(:command_string)  { CommandString.new("Alice, please give Robyn the tomato.") }
    let(:parser)          { Alice::Parser::Mash.new(command_string) }

    before do
      parser.parse!
    end

    it "recognizes the tomato object" do
      expect(parser.this_object).to eq(@tomato)
    end

    it "recognizes the Robyn user" do
      expect(parser.this_subject).to eq(@robyn)
    end

  end

  context "Alice, who is Syd?" do

    let(:command_string)  { CommandString.new("Alice, who is Syd?") }
    let(:parser)          { Alice::Parser::Mash.new(command_string) }

    before do
      parser.parse!
    end

    it "recognizes the Syd user" do
      expect(parser.this_subject).to eq(@syd)
    end

  end

  context "Alice, what is Syd's twitter handle?" do

    context "happy path" do

      let(:command_string)  { CommandString.new("Alice, what is Syd's twitter handle?") }
      let(:parser)          { Alice::Parser::Mash.new(command_string) }

      before do
        parser.parse!
      end

      it "recognizes the Syd user" do
        expect(parser.this_subject).to eq(@syd)
      end

      it "maps the object to a whitelisted instance method" do
        expect(parser.this_property).to eq :twitter_handle
      end

    end

    context "edge cases" do

      let(:command_string)  { CommandString.new("Alice, what is Syd's destroy?") }
      let(:parser)          { Alice::Parser::Mash.new(command_string) }

      before do
        parser.parse!
      end

      it "does not map to a non-whitelisted instance method" do
        expect(parser.this_property).to be_nil
      end

    end

  end

  context "Alice, who made the tomato?" do

      let(:command_string)  { CommandString.new("Alice, who made the tomato?") }
      let(:parser)          { Alice::Parser::Mash.new(command_string) }

      before do
        parser.parse!
      end

      xit "recognizes the tomato object" do
        expect(parser.this_object).to eq(@tomato)
      end

      xit "maps to the object's creator method" do
        expect(parser.this_property).to eq(:creator)
      end

  end

end
