module Api
  module V1
    class SeasonReport
      def self.perform
        season = Season.last
        teams = Team.where(season: season)
        points = season.scores.group_by{|s| s.team_id}
        season_scores = []
        points.each do |k,v|
          data = Hash.new
          data["team_id"] = k
          data["team_name"] = teams.find(k).name
          data["player_name"] = teams.find(k).player.name
          first_half_rounds = v.select{|x| x.round.number <= 19}
          second_half_rounds = v.select{|x| x.round.number > 19}
          data["first_half_points"] = first_half_rounds.sum(&:final_score)
          data["second_half_points"] = second_half_rounds.sum(&:final_score)
          data["season_score"] =  data["first_half_points"] + data["second_half_points"]
          season_scores << data
          # data["first_half_scores"] =
        end
        season_scores = season_scores.sort_by{|s| s["season_score"]}.reverse
        $redis.set("season_scores", season_scores.to_json)
      end
    end
  end
end
