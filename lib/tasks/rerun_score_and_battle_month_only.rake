desc "This task is called by the Heroku scheduler add-on"
task :rerun_score_and_battle_month_only => :environment do
  puts "recalculating scores..."
  ::Score.rerun_scores(true)
  puts "recalculating battles..."
  ::Battle.rerun_battles(true)
  puts "updating REDIS data..."
  ::Round.round_finished_routines
  puts "... done!"
end
