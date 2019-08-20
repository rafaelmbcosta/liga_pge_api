desc "This task is called by the Heroku scheduler add-on"
task :round_finished_tasks => :environment do
  puts "Running round finished tasks..."
  Api::V1::Round.round_finished_routines
  puts "... done"
end
