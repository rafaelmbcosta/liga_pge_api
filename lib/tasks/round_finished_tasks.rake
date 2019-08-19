desc "This task is called by the Heroku scheduler add-on"
task :round_finished_tasks => :environment do
  Api::V1::ScoresWorker.perform('finished_round')
  Api::V1::BattleWorker.perform('finished_round')
  Api::V1::CurrencyWorker.perform
  puts "Running turn and championshipt scores tasks..."
  Api::V1::SeasonWorker.perform("finished_round")
end
