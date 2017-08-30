module Api
  module V1
    class CurrencyReport

      def self.perform
        season = Season.last
        teams = Team.where(active: true)
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
            team_hash["difference"] = nil
            team_hash["details"] =  []
            initial_currency = nil
            team_currencies = Currency.where("team_id = ? and round_id in(?)", team.id, dm.dispute_rounds).order("round_id asc")
            unless team_currencies.empty?
              team_hash["difference"] = team_currencies.collect{|c| c.difference}.sum
              team_currencies.each do |currency|
                team_hash["details"] << { :value => currency.value, :difference => currency.difference, :round => currency.round.number}
              end
            end
            dispute_month["teams"] << team_hash unless team_hash["difference"].nil?
          end
          dispute_month["teams"].sort_by!{|t| t["difference"]}
          currencies << dispute_month unless dispute_month["teams"].empty?
        end
        currencies.sort_by!{|c| c["id"]}.reverse!
        $redis.set("currencies", currencies.to_json)
      end
    end
  end
end
