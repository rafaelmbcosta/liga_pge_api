module Api
  module V1
    class PartialScore

      def self.perform
        last_round = Round.last
        teams = Team.where(season: last_round.season)
        teams.each do |team|
            pontuacao = Connection.team_score(team.slug, last_round.number)
            points = pontuacao["atletas"].sum{|k,v| k["pontos_num"]}
            score = Score.find{|sc| sc.team_id == team.id and  sc.round_id == last_round.id}
            if score.nil?
              score = Score.create(team: team, round: last_round,
                  partial_score: points, team_name: team.name,
                  player_name: team.player.name )
            else
              score.update_attributes(partial_score: points)
            end
        end
      end
    end
  end
end
