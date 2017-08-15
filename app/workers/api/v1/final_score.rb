module Api
  module V1
    class FinalScore
      def self.perform(round)
        market_status = Connection.market_status
        unless market_status["status_mercado"] ==  4
          teams = Team.where(season: round.season, active: true)
          teams.each do |team|
            pontuacao = Connection.team_score(team.slug, round.number)
            points = pontuacao["pontos"] || 0
            score = Score.find{|sc| sc.team_id == team.id and  sc.round_id == round.id}
            if score.nil?
              score = Score.create(team: team, round: round,
                  final_score: points.round(2), team_name: team.name,
                  player_name: team.player.name)
            else
              score.update_attributes(final_score: points.round(2))
            end
            round.update_attributes(finished: true)
          end
          BattleResults.perform(round)
        end
      end
    end
  end
end
