require 'spec_helper'

describe Door do

  it "creates its counterpart" do
    Place::NEIGHBOR_COORDS.each do |x,y|
      door = Door.from([0,0]).to([x,y])
      door.save
      expect(door.counterpart).to_not be_nil
    end
  end

end

