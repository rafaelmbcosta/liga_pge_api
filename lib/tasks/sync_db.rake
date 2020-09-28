desc "Setup database to match production"
require 'open-uri'
require 'database_cleaner'
task :sync_db => :environment do
  if ['development', 'test'].include?(Rails.env)
    puts "reseting database..."
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean
    puts "creating season..."
    season = Api::V1::Season.create(year: Time.now.year)
    puts "getting teams..."
    uri = URI('http://cartola-pge-api.herokuapp.com/api/v1/teams')
    teams =  Api::V1::Connection.connect(uri)
    teams.each do |team|
      Api::V1::Team.create(team.except("id"))
    end
    puts "gettin dispute months..."
    uri = URI('http://cartola-pge-api.herokuapp.com/api/v1/dispute_months/list')
    dms =  Api::V1::Connection.connect(uri)
    dms.each do |dm|
      dm["season_id"] = season.id
      Api::V1::DisputeMonth.create(dm.except("id"))
    end

    puts "creating rounds..."
    current_round = Api::V1::Connection.current_round - 1
    (1..current_round).to_a.each do |round_number|
      puts "ROUND #{round_number}"
      market = { 'rodada_atual' => round_number, 'close_date' => Time.now}
      Api::V1::Round.new_round(season, market)
      Api::V1::Round.close_market
      raise  Api::V1::Round.first.round_control.inspect
      Api::V1::Round.closed_market_routines
      Api::V1::Round.finish_round
      Api::V1::Round.round_finished_routines
    end
    puts "running jobs..."

    puts "... done!"
  end
end
