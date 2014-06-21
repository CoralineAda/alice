namespace :database do

  desc "Copy production database to local"
  task :sync_to_local => :environment do
    system "mongodump -h #{ENV['DB_HOST']} -d alicebot -u #{ENV['DB_USER']} -p #{ENV['DB_USER']} -o db/backups/"
    system 'mongorestore -h localhost --drop -d alice_dev db/backups/app475686/'
  end

end