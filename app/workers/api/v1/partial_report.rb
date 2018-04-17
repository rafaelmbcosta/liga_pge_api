module Api
  module V1
    class PartialReport

      def self.perform
        Team.where(active: true, season: Season.last).each do |team|
          partial(team)
        end
      end

      def self.opponent(battle, team, teams)
        opponent_id = nil
        battle.first_id == team.id ? opponent_id = battle.second_id : opponent_id = battle.first_id
        opponent_id.nil? ? (return "Fantasma") : (return "#{teams.find(opponent_id).name}")
      end

      def self.partial(team)
        last_round = Round.where(season: Season.last).last
        team_athletes = Connection.team_score(team.slug, last_round.number)
        athletes = Connection.athletes_scores
        result = []
        positions = team_athletes["posicoes"]
        captain_id = team_athletes["capitao_id"]
        team_athletes["atletas"].each do |team_athlete|
          partial = Hash.new
          partial["nickname"] = team_athlete["apelido"]
          partial["points"] = "-"
          partial["scouts"] = "-"
          partial["captain"] = (team_athlete["atleta_id"] == captain_id) ? true : false
          partial["position_id"] = team_athlete["posicao_id"]
          partial["position"] = positions[team_athlete["posicao_id"].to_s]["nome"]
          partial["position_id"] =  team_athlete["posicao_id"]
          partial["team_name"] = team.name
          partial["player_name"] = team.player.name
          partial["team"] = team_athletes["clubes"][team_athlete["clube_id"].to_s]["abreviacao"]
          partial["team_logo"] = team_athletes["clubes"][team_athlete["clube_id"].to_s]["escudos"]["45x45"]
          # partial["situacao"] = "empate"
          athlete_id = team_athlete["atleta_id"].to_s
          if athletes["atletas"].include?(athlete_id)
            player_points = athletes["atletas"][athlete_id.to_s]["pontuacao"]
            partial["points"] = player_points
            scouts = athletes["atletas"][athlete_id.to_s]["scout"]
            partial["scouts"] = scouts.collect{|k,v| "#{k}x#{v}"}.join(" ").gsub("x1","")
          end
          result << partial
        end
        $redis.set("partial_#{team.id}",result.sort_by{|r| r["position_id"].to_i}.to_json)
      end
    end
  end
end
