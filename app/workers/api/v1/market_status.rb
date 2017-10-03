module Api
  module V1
    class MarketStatus
      def self.create_activities(dispute_month)
        Team.all.where("active is true").each do |team|
          activity = MonthActivity.find{|ma| ma.dispute_month.id == dispute_month.id && ma.team.id == team.id }
          MonthActivity.create(team: team, dispute_month: dispute_month, active: true, payed: true) if activity.nil?
        end
      end

      def self.verify_season(year)
        season = Season.find{|s| s.year == year}
        if season.nil?
          # gotta update the dispute months
          previous_season = Season.find{|s| s.year == (year - 1)}
          unless previous_season.nil?
            previous_season.finished = true
            previous_season.save
          end
          season = Season.create(year: year, finished: false)
        end
        return season
      end

      def self.verify_round(number, season)
       round = Round.find{|r| r.season.id == season.id and r.number == number}
       if round.nil?
         ## verify if its golden (on seasons)
         golden = season.golden_rounds.include?(number)
         ## verify dispute month (if configured )
         dispute = DisputeMonth.find{|d| d.season_id == season.id and d.dispute_rounds.include?(number)}
         round = Round.create(number: number, season: season, dispute_month: dispute, golden: golden, finished: false)
         create_activities(dispute)
       end
       return round
      end

      def self.perform
        market_status = Connection.market_status
        season = verify_season(market_status["temporada"])
        current_round = market_status["rodada_atual"]
        round = verify_round(current_round, season)
        unless market_status["game_over"]
          fechamento = market_status["fechamento"]
          if market_status["status_mercado"] == 2 #Closed
            NewBattle.perform(round) if (round.battles.empty? && Time.now.day == fechamento["dia"] &&
              Time.now.month == fechamento["mes"] && Time.now.year == fechamento["ano"] )
              puts "Round id: #{round.id} number: #{round.number}"
            PartialScore.perform(round)
          end
          if market_status["status_mercado"] == 1 # Open
            # Check if the market is open
            previous_round = Round.find{|r| r.number == round.number-1 and r.finished == false}
            FinalScore.perform(previous_round) unless previous_round.nil?
            FinalCurrency.perform(previous_round) unless previous_round.nil?
            AwardWorker.perform(previous_round) unless previous_round.nil?
            previous_round.update_attributes(finished: true)
          end
        end
      end
    end
  end
end
