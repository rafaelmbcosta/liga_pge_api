module Api
  module V1
    class PartialScore

      def self.perform
        last_round = Round.last
        teams = Team.where(season: last_round.season)
        teams.each do |team|
            pontuacao = Web::ApiCartola::Connection.team_score(team.slug, last_round.number)
            score = Score.find{|sc| sc.team_id == team.id and  sc.round_id == last_round.id}
            if score.nil?
              score = Score.create(team: team, round: last_round,
                  partial_score: pontuacao["pontos"], team_name: team.name,
                  player_name: team.player.name )
            else
              score.update_attributes(partial_score: pontuacao["pontos"])
            end
        end
      end
    end
  end
end
