namespace :database do

  desc "Copy production database to local"
  task :sync_to_local do
    system "mongodump -h #{ENV['DB_HOST']} -d alicebot -u #{ENV['DB_USER']} -p #{ENV['DB_PASS']} -o db/backups/"
    system 'mongorestore -h localhost --drop -d alice_dev db/backups/alicebot/'
  end

  desc "Back up local"
  task :backup_local do
    system "mongodump -h localhost -d alice_dev -o db/backups/"
  end

  desc "Back up production"
  task :backup_local do
    system "mongodump -h localhost -d alice_prod -o db/backups/"
  end

  desc "Copy local database to production"
  task :sync_to_prod_do_not_use do
    system "mongodump -h localhost -d alice_dev -o db/backups/"
    system "mongorestore -h #{ENV['DB_HOST']} --drop -d alicebot -u #{ENV['DB_USER']} -p #{ENV['DB_PASS']} db/backups/alice_dev"
  end


end