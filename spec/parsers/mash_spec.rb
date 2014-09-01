require 'spec_helper'

describe "Alice::Parser::Mash" do

  robyn  = User.create(primary_nick: "robyn")
  syd    = User.create(primary_nick: "syd")
  tomato = Item.create(name: "tomato")

  context "Alice, please give the tomato to Robyn." do

    let(:command_string)  { CommandString.new("Alice, please give the tomato to Robyn.") }
    let(:parser)          { Alice::Parser::Mash.new(command_string) }

    before do
      parser.parse!
    end

    it "recognizes the tomato object" do
      expect(parser.this_object).to eq(tomato)
    end

    it "recognizes the Robyn user"

  end

end