desc "This task is called by the Heroku scheduler add-on"
task :previous_currencies => :environment do
  puts "Setting currencies"
  (1..22).to_a.each do |number|
    round = Api::V1::Round.find{|r| r.number == number}
    Api::V1::FinalCurrency.perform(round) unless round.nil?
  end
  puts "done."
end
