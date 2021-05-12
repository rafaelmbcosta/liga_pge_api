desc "This task is called by the Heroku scheduler add-on"
task :closed_market_tasks => :environment do
  puts "Running closed market tasks ..."
  ::Round.closed_market_routines
  puts "done."
end
