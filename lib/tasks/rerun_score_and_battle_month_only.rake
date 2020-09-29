desc "This task is called by the Heroku scheduler add-on"
task :rerun_score_and_battle_month_only => :environment do
  puts "recalculating scores..."
  Api::V1::Score.rerun_scores(true)
  puts "recalculating battles..."
  Api::V1::Battle.rerun_battles(true)
  puts "updating REDIS data..."
  Api::V1::Round.round_finished_routines
  puts "... done!"
end
