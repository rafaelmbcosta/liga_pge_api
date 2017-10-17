module Api
  module V1
    class SeasonReport

      def self.fill_data(hash, team_id, team_name, player_name, points, url_escudo_png)
        hash["scores"] << { "team_id" => team_id, "team_name" => team_name,
              "player_name" => player_name, "season_score" => points, "team_symbol" => url_escudo_png }
      end

      def self.perform
        season = Season.last
        teams = Team.where(season: season)
        points = season.scores.group_by{|s| s.team_id}
        first_half_data =  { "title" => "Primeiro Turno", "scores" => []}
        second_half_data = { "title" => "Segundo Turno", "scores" => []}
        full_season_data = { "title" => "Campeonato", "scores" => []}
        points.each do |k,v|
          team_id = k
          team_name = teams.find(k).name
          player_name = teams.find(k).player.name
          symbol_url = teams.find(k).url_escudo_png
          first_half_rounds = v.select{|x| x.round.number <= 19}
          first_half_points = first_half_rounds.sum(&:final_score)
          fill_data(first_half_data, team_id, team_name, player_name, first_half_points, symbol_url)
          second_half_rounds = v.select{|x| x.round.number > 19}
          second_half_points = second_half_rounds.sum(&:final_score)
          fill_data(second_half_data, team_id, team_name, player_name, second_half_points, symbol_url)
          full_season_points =  first_half_points + second_half_points
          fill_data(full_season_data, team_id, team_name, player_name, full_season_points, symbol_url)
        end
        first_half_data["scores"].sort_by!{|s| s["season_score"]}.reverse! unless first_half_data.empty?
        second_half_data["scores"].sort_by!{|s| s["season_score"]}.reverse! unless second_half_data.empty?
        full_season_data["scores"].sort_by!{|s| s["season_score"]}.reverse! unless full_season_data.empty?
        season_scores = [first_half_data, second_half_data, full_season_data]
        $redis.set("season_scores", season_scores.to_json)
      end
    end
  end
end
