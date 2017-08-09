desc "This task is called by the Heroku scheduler add-on"
task :update_reports => :environment do
  puts "Updating Battles..."
  Api::V1::BattlesReport.perform
  puts "Updating League results..."
  Api::V1::LeagueReport.perform
  puts "Scores Battles..."
  Api::V1::ScoresReport.perform
  puts "Scores Season..."
  Api::V1::SeasonReport.perform
  puts "done."
end
