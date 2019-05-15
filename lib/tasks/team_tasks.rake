desc "This task is called by the Heroku scheduler add-on"
task :team_tasks => :environment do
  puts "Running tasks ..."
  Api::V1::TeamWorker.perform 
  puts "done."
end
