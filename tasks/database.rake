namespace :database do

  desc "Dump all data as json"
  task :dump_to_json do
    Actor.all.each{ |actor| p actor.to_json }
    Beverage.all.each{ |actor| p actor.to_json }
    Bio.all.each{ |actor| p actor.to_json }
    Catchphrase.all.each{ |actor| p actor.to_json }
    Context.all.each{ |actor| p actor.to_json }
    Door.all.each{ |actor| p actor.to_json }
    Factoid.all.each{ |actor| p actor.to_json }
    Item.all.each{ |actor| p actor.to_json }
    Message::Command.all.each{ |actor| p actor.to_json }
    OH.all.each{ |actor| p actor.to_json }
    Place.all.each{ |actor| p actor.to_json }
    Place.all.each{ |actor| p actor.to_json }
    User.all.each{ |actor| p actor.to_json }
    Wand.all.each{ |actor| p actor.to_json }
  end

  desc "Copy production database to local"
  task :sync_to_local do
    system "mongodump -h #{ENV['DB_HOST']} -d alicebot -u #{ENV['DB_USER']} -p #{ENV['DB_PASS']} -o db/backups/"
    system 'mongorestore -h localhost --drop -d alice_dev db/backups/alicebot/'
  end

  desc "Copy production database to test"
  task :sync_to_test do
    system "mongodump -h #{ENV['DB_HOST']} -d alicebot -u #{ENV['DB_USER']} -p #{ENV['DB_PASS']} -o db/backups/"
    system 'mongorestore -h localhost --drop -d alice_test db/backups/alicebot/'
  end

  desc "Back up local"
  task :backup_local do
    system "mongodump -h localhost -d alice_dev -o db/backups/"
  end

  desc "Back up production"
  task :backup_prod do
    system "mongodump -h #{ENV['DB_HOST']} -d alicebot -u #{ENV['DB_USER']} -p #{ENV['DB_PASS']} -o db/backups/"
  end

  desc "Restore production from backup"
  task :restore_prod do
    system "mongorestore -h #{ENV['DB_HOST']} -d alicebot -u #{ENV['DB_USER']} -p #{ENV['DB_PASS']} db/backups/alicebot/"
  end

  desc "Copy local database to production"
  task :sync_to_prod_do_not_use do
    system "mongodump -h localhost -d alice_dev -o db/backups/"
    system "mongorestore -h #{ENV['DB_HOST']} --drop -d alicebot -u #{ENV['DB_USER']} -p #{ENV['DB_PASS']} db/backups/alice_dev"
  end

end
