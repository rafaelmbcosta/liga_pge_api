module Api
  module V1
    class PartialReport

      def self.perform
        last_round = Round.last
        scores = Score.where(round: last_round).order('partial_score desc')
        $redis.set("partials", scores.to_json)
        Team.where("active is true").each do |team|
          partial(team)
        end
      end

      def self.partial(team)
        last_round = Round.last
        team_athletes = Connection.team_score(team.slug, last_round.number)
        athletes = Connection.athletes_scores
        result = []
        team_athletes["atletas"].each do |team_athlete|
          partial = Hash.new
          partial["nickname"] = team_athlete["apelido"]
          partial["points"] = "-"
          partial["scouts"] = "-"
          partial["team_name"] = team.name
          partial["player_name"] = team.player.name
          partial["team"] = team_athletes["clubes"][team_athlete["clube_id"].to_s]["abreviacao"]
          partial["team_logo"] = team_athletes["clubes"][team_athlete["clube_id"].to_s]["escudos"]["45x45"]
          athlete_id = team_athlete["atleta_id"].to_s
          if athletes["atletas"].include?(athlete_id)
            partial["points"] = athletes["atletas"][athlete_id.to_s]["pontuacao"]
            scouts = athletes["atletas"][athlete_id.to_s]["scout"]
            partial["scouts"] = scouts.collect{|k,v| "#{k}x#{v}"}.join(" ").gsub("x1","")
          end
          result << partial
        end
        $redis.set("partial_#{team.id}",result.to_json)
      end
    end
  end
end
