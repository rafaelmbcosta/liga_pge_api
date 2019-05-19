desc "This task is called by the Heroku scheduler add-on"
task :general_tasks => :environment do
  puts "Running tasks ..."
  Api::V1::RoundWorker.perform
  puts "Running team tasks"
  Api::V1::TeamWorker.perform
  puts "done."
end
