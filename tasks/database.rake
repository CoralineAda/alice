namespace :database do

  desc "Copy production database to local"
  task :sync_to_local do
    system "mongodump -h #{ENV['DB_HOST']} -d alicebot -u #{ENV['DB_USER']} -p #{ENV['DB_PASS']} -o db/backups/"
    system 'mongorestore -h localhost --drop -d alice_dev db/backups/alicebot/'
  end

end