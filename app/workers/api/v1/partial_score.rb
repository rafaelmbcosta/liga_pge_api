module Api
  module V1
    class PartialScore

      def self.opponent(id, teams, round)
        opponent_name = ""
        opponent_points = 0
        if id.nil?
          opponent_name = "Fantasma"
          opponent_points = round.ghost_partial_score
        else
          opponent_name = teams.find{|t| t.id == id}.name
          score = Score.find{|s| s.round_id == round.id and s.team_id == id}
          opponent_points = score.partial_score unless score.nil?
        end
        return opponent_name, opponent_points
      end

      def self.battle_status(battle, team, teams, score)
        battle_class = ""
        opponent_name = ""
        diff_points = 0
        opponent_points = 0

        if battle.first_id == team.id
          opponent_id = battle.second_id
          opponent_name, opponent_points = opponent(opponent_id, teams, battle.round)
        else
          opponent_id = battle.first_id
          opponent_name, opponent_points = opponent(opponent_id, teams, battle.round)
        end
        if (score.partial_score - opponent_points).abs > 5
          (score.partial_score > opponent_points) ? battle_class = "success" : battle_class = "danger"
        end
        diff_points = (score.partial_score - opponent_points).abs
        return battle_class, opponent_name, diff_points
      end

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
          battle = Battle.find{|b| (b.first_id == team.id or b.second_id == team.id) and b.round_id == last_round.id}
          attributes = score.attributes
          attributes["team_symbol"] = pontuacao["time"]["url_escudo_png"]
          attributes["battle_class"], attributes["battle_opponent"], attributes["diff_points"] = battle_status(battle, team, teams, score)
          scores << attributes
        end
        $redis.set("partials", scores.sort_by{|r| r["partial_score"]}.reverse.to_json)
        PartialReport.perform
      end
    end
  end
end
