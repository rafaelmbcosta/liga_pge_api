desc "This task is called by the Heroku scheduler add-on"
task :round_tasks => :environment do
  puts "Running tasks ..."
  Api::V1::RoundWorker.perform 
  puts "done."
end
