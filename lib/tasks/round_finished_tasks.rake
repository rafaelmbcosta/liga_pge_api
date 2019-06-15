desc "This task is called by the Heroku scheduler add-on"
task :round_finished_tasks => :environment do
  Api::V1::ScoresWorker.perform('finished_round')
  Api::V1::BattleWorker.perform('finished_round')
  Api::V1::CurrencyWorker.perform
end
