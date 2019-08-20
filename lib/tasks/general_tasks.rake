desc "This task is called by the Heroku scheduler add-on"
task :general_tasks => :environment do
  puts "Running tasks ..."
  Api::V1::RoundWorker.perform
  puts "Running team tasks"
  Api::V1::TeamWorker.perform
  puts "Sreating new season if needed"
  Api::V1::SeasonWorker.perform("season_finished")
  puts "done."
end
