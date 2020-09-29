desc "This task is called by the Heroku scheduler add-on"
task :rerun_all_scores_and_battles => :environment do
  puts "recalculating scores..."
  Api::V1::Score.rerun_scores
  puts "recalculating battles..."
  Api::V1::Battle.rerun_battles
  puts "updating REDIS data..."
  Api::V1::Round.round_finished_routines
  puts "... done!"
end
