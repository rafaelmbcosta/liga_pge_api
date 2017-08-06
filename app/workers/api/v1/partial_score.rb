module Api
  module V1
    class PartialScore

      def self.perform(last_round)
        teams = Team.where(season: last_round.season)
        athletes = Connection.athletes_scores["atletas"]
        scores = []
        teams.each do |team|
          pontuacao = Connection.team_score(team.slug, last_round.number)
          points = 0
          players = 0
          pontuacao["atletas"].each do |athlete|
            athlete_id = athlete["atleta_id"]
            if athletes.include?(athlete_id.to_s)
              points += athletes[athlete_id.to_s]["pontuacao"]
              players += 1
            end
          end
          score = Score.find{|sc| sc.team_id == team.id and  sc.round_id == last_round.id}
          if score.nil?
            score = Score.create(team: team, round: last_round,
                partial_score: points, team_name: team.name,
                player_name: team.player.name, players: players )
          else
            score.update_attributes(partial_score: points, players: players)
          end
          attributes = score.attributes
          attributes["team_symbol"] = pontuacao["time"]["url_escudo_png"]
          scores << attributes
        end
        $redis.set("partials", scores.sort_by{|r| r["partial_score"]}.reverse.to_json)
        PartialReport.perform
      end
    end
  end
end
