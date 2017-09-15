class ForceCreateIsACategoryUuidConstraint < Neo4j::Migrations::Base
  def up
    add_constraint :"IsA::Category", :uuid, force: true
  end

  def down
    drop_constraint :"IsA::Category", :uuid
  end
end
