desc "This task is called by the Heroku scheduler add-on"
task :rerun_all_scores_and_battles => :environment do
  puts "recalculating scores..."
  ::Score.rerun_scores
  puts "recalculating battles..."
  ::Battle.rerun_battles
  puts "updating REDIS data..."
  ::Round.round_finished_routines
  puts "... done!"
end
