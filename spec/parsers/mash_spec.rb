require 'spec_helper'

describe "Alice::Parser::Mash" do

  before do
    @robyn  = User.create!(primary_nick: "robyn")
    @syd    = User.create!(primary_nick: "syd")
    @tomato = Item.create!(name: "tomato")
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

  context "Alice, look at Syd" do

    let(:command_string)  { CommandString.new("Alice, look at Syd.") }
    let(:parser)          { Alice::Parser::Mash.new(command_string) }

    before do
      parser.parse!
    end

    it "recognizes the Syd user" do
      p parser.state
      expect(parser.this_subject).to eq(@syd)
    end

  end

end