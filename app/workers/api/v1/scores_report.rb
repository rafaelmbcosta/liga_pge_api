module Api
  module V1
    class ScoresReport

      def self.perform
        dispute_months = DisputeMonth.where(season: Season.last)
        teams = Team.where(active: true)
        months = []
        dispute_months.each do |dm|
          scores = dm.scores
          month = Hash.new
          month["name"] = dm.name
          month["id"] = dm.id
          month["players"] = Array.new
          if scores.any?
            teams.each do |team|
              player = Hash.new
              player["name"] = team.player.name
              player["team"] = team.name
              player["points"] = 0
              player["team_symbol"] = team.url_escudo_png
              player["details"] = Array.new
              player_scores = scores.where("team_id = ?", team.id)
              player_scores.each do |score|
                detail = Hash.new
                detail["round"] = score.round.number
                detail["points"] = score.final_score
                player["points"] += score.final_score
                player["details"] << detail
              end
              player["points"] = player["points"].round(2)
              month["players"] << player
            end
            month["players"].sort_by!{ |e| e["points"] }.reverse!
            months << month
          end
        end
        $redis.set("scores", months.reverse.to_json)
      end
    end
  end
end
