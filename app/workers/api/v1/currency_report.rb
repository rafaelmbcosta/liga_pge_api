module Api
  module V1
    class CurrencyReport

      def self.perform
        season = Season.last
        teams = Team.where(active: true, season: season)
        currencies = []
        season.dispute_months.each do |dm|
          dispute_month = Hash.new
          dispute_month["name"] = dm.name
          dispute_month["id"] = dm.id
          dispute_month["teams"] = Array.new
          teams.each do |team|
            team_hash = Hash.new
            team_hash["name"] = team.name
            team_hash["player"] = team.player.name
            team_hash["team_symbol"] = team.url_escudo_png
            team_hash["difference"] = nil
            team_hash["details"] =  []
            initial_currency = nil
            team_currencies = Currency.select{|c| c.team_id == team.id and c.round.number.in?(dm.dispute_rounds)}
            unless team_currencies.empty?
              team_hash["difference"] = team_currencies.collect{|c| c.difference}.sum
              team_currencies.each do |currency|
                team_hash["details"] << { :value => currency.value, :difference => currency.difference, :round => currency.round.number}
              end
              team_hash["details"].sort_by!{|d| d[:round]}
            end
            dispute_month["teams"] << team_hash unless team_hash["difference"].nil?
          end
          dispute_month["teams"].sort_by!{|t| t["difference"]}.reverse!
          currencies << dispute_month unless dispute_month["teams"].empty?
        end
        currencies.sort_by!{|c| c["id"]}.reverse!
        $redis.set("currencies", currencies.to_json)
      end
    end
  end
end
