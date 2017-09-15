class ForceCreateIsACharacteristicUuidConstraint < Neo4j::Migrations::Base
  def up
    add_constraint :"IsA::Characteristic", :uuid, force: true
  end

  def down
    drop_constraint :"IsA::Characteristic", :uuid
  end
end
