desc "This task is called by the Heroku scheduler add-on"
task :update_reports => :environment do
  puts "Updating team symbols"
  Api::V1::TeamWorker.perform
  puts "Updating Battles..."
  Api::V1::BattlesReport.perform
  puts "Updating League results..."
  Api::V1::LeagueReport.perform
  puts "Scores Battles..."
  Api::V1::ScoresReport.perform
  puts "Scores Season..."
  Api::V1::SeasonReport.perform
  puts "Currency Report..."
  Api::V1::CurrencyReport.perform
  puts "Championship prizes"
  Api::V1::ChampionshipReport.perform
  puts "Monthly prizes report"
  Api::V1::MonthlyAwardReport.perform
  puts "done."
end
