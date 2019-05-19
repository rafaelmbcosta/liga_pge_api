desc "This task is called by the Heroku scheduler add-on"
task :closed_market_tasks => :environment do
  puts "Running battle tasks ..."
  Api::V1::BattleWorker.perform("closed_market")
  puts "Creating scores task ..."
  Api::V1::ScoresWorker.perform("closed_market")
  puts "done."
end
