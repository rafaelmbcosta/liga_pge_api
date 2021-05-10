desc "Setup database to match production"


task :sync_db => :environment do
  if ['development', 'test'].include?(Rails.env)
    require 'open-uri'
    require 'database_cleaner'
    puts 'reseting database...'
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean
    puts 'creating season...'
    Season.sync
    puts 'getting teams...'
    ::Team.sync
    puts 'gettin dispute months...'
    ::DisputeMonth.sync
    puts "creating rounds..."
    ::Round.sync
    puts "getting scores..."
    ::Score.sync
    puts "gettting battles..."
    ::Battle.sync
    puts "updating REDIS data..."
    ::Round.round_finished_routines
    puts "... done!"
  end
end
