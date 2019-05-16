desc "This task is called by the Heroku scheduler add-on"
task :battle_tasks => :environment do
  puts "Running tasks ..."
  Api::V1::BattleWorker.perform 
  puts "done."
end
