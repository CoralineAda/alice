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

    let(:command_string)  { CommandString.new("Alice, what is Syd's twitter handle?") }
    let(:parser)          { Alice::Parser::Mash.new(command_string) }

    before do
      parser.parse!
    end

    it "recognizes the Syd user" do
      binding.pry
      expect(parser.this_subject).to eq(@syd)
    end

  end

end