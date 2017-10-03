module Api
  module V1
    class AwardWorker

      def self.award_champions(season)
        # Prizes for 1 2 and 3
        prizes = season.championship_prize
        second_half_prize = season.second_half_prize
        # Collects the first 3 scorers from the championship
        team_scores = season.scores.joins(:team).where("teams.active is true").group_by{|s| s.team}
        team_scores = team_scores.collect{|ts| {team_id: ts[0].id, scores: ts[1].sum(&:final_score)}}.sort_by{|x| x[:scores]}.last(3).reverse
        # Collects the first 3 scorers from the second half
        second_half_scores = season.scores.joins(:team).where("teams.active is true").select{|ts| ts.round.number >= 19}.group_by{|s| s.team}
        second_half_scores = second_half_scores.collect{|ts| {team_id: ts[0].id, scores: ts[1].sum(&:final_score)}}.sort_by{|x| x[:scores]}.last(3).reverse
        (0..2).to_a.each do |i|
          # Second Turn
          x = Award.create(team_id: second_half_scores[i][:team_id], season: season, award_type: 4, position: i+1, prize: second_half_prize[i] )
          # Championship
          Award.create(team_id: team_scores[i][:team_id], season: season, award_type: 0, position: i+1, prize: prizes[i] )
        end
      end

      def self.award_first_turn(season)
        first_half_prize = season.first_half_prize
        first_half_scores = season.scores.joins(:team)
          .where("teams.active is true")
          .select{|ts| ts.round.number >= 19}
          .group_by{|s| s.team}
          .collect{|ts| {team_id: ts[0].id, scores: ts[1].sum(&:final_score)}}
          .sort_by{|x| x[:scores]}
          .last(3).reverse
        (0..2).to_a.each do |i|
          x = Award.create(team_id: first_half_scores[i][:team_id], season: season, award_type: 3, position: i+1, prize: first_half_prize[i] )
        end
      end

      def self.award_golden(round)
        golden_prize = round.dispute_month.golden_prize
        winners = round.scores.joins(:team)
          .where("teams.active is true")
          .group_by{ |s| s.team }
          .collect{|ts| {team_id: ts[0].id, scores: ts[1].sum(&:final_score)}}
          .sort_by{|x| x[:scores]}
          .last(3).reverse
        (0..2).to_a.each do |i|
          x = Award.create(team_id: winners[i][:team_id],
          season: round.season,
          award_type: 5,
          position: i+1,
          dispute_month: round.dispute_month,
          prize: golden_prize[i],
          round: round)
        end
      end

      def self.award_month(dispute)
        monthly_prize = dispute.monthly_prize
        winners = dispute.scores.joins(:team)
          .where("teams.active is true")
          .group_by{ |s| s.team }
          .collect{|ts| {team_id: ts[0].id, scores: ts[1].sum(&:final_score)}}
          .sort_by{|x| x[:scores]}
          .last(3).reverse
        (0..2).to_a.each do |i|
          x = Award.create(team_id: winners[i][:team_id],
          season: dispute.season,
          award_type: 1,
          dispute_month: dispute,
          position: i+1,
          prize: monthly_prize[i])
        end
      end

      def self.award_league(dispute)
        league_prize = dispute.league_prize
        LeagueReport.perform
        winners = JSON.parse($redis.get("league")).select{|l| l["id"] == dispute.id}
        winners = winners[0]["players"][0..2]
        (0..2).to_a.each do |i|
          x = Award.create(team_id: winners[i]["id"],
          season: dispute.season,
          award_type: 2,
          dispute_month: dispute,
          position: i+1,
          prize: league_prize[i])
        end
      end

      def self.award_currency(dispute)
        dispute_month_winners = Award.where(dispute_month_id: dispute.id, season: dispute.season).collect{|aw| aw.team_id }.uniq
        currency_ranking = dispute.currencies
          .select{|not_winner| !dispute_month_winners.include?(not_winner.id)}
          .group_by{|c| c.team_id }
          .collect{|score| { team_id: score[0], difference: score[1].sum(&:difference) }}
          .sort_by{|currencies| currencies[:difference]}
          .reverse
        winner_id = currency_ranking.first[:team_id]
        Award.create(team_id: winner_id,
          season: dispute.season,
          award_type: 6,
          dispute_month: dispute,
          prize: dispute.currency_prize)
      end

      def self.perform(round)
        dispute = round.dispute_month
        # Championship AND  second_turn
        award_champions(round.season) if round.number == 38
        # First turn (check if its in the middle of the month)
        award_first_turn(round.season) if round.number == 19

        ## Golden round
        award_golden(round) if round.golden

        # Monthly awards:
        if dispute.dispute_rounds.last == round.number
          ## Month
          award_month(dispute)
          ## League
          award_league(dispute)
          ## Patrimônio
          award_currency(dispute)
        end
      end
    end
  end
end
