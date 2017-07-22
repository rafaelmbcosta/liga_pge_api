desc "This task is called by the Heroku scheduler add-on"
task :update_scores => :environment do
  puts "Updating scores..."
  Api::V1::MarketStatus.perform 
  puts "done."
end
