desc "Setup database to match production"
task :sync_db => :environment do
  puts "Reseting database"
  require 'database_cleaner'
  DatabaseCleaner.strategy = :truncation
  # then, whenever you need to clean the DB
  DatabaseCleaner.clean
  puts "... done"
  puts "Getting teams"
  # cartola-pge-api.herokuapp.com/api/v1/dispute_months
  puts "Get Season and dispute months"
  season = Api::V1:Season.create(year: Time.now.year)
  puts "Getting Current Round"

  puts "Create all Rounds"
end
