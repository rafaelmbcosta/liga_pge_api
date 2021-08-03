desc "This task is called by the Heroku scheduler add-on"
task :rerun_currencies => :environment do
  rounds = (1..14)
  rounds.to_a.each do |number|
    puts "saving currencies round #{number}"
    round = Round.find { |r| r.season == Season.active &&  r.number ==  number }
    Currency.save_currencies_round(round)
  end
  Currency.show_currencies
end
