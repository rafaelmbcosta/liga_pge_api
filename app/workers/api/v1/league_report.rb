module Api
  module V1
    class LeagueReport

      def self.opponent(battle, team, teams)
        opponent_id = nil
        battle.first_id == team.id ? opponent_id = battle.second_id : opponent_id = battle.first_id
        opponent_id.nil? ? (return "Fantasma") : (return "#{teams.find(opponent_id).name}")
      end

      def self.perform
        dispute_months = DisputeMonth.where(season: Season.last)
        teams = Team.where(season: Season.last)
        leagues = []
        dispute_months.each do |dm|
          battles = dm.battles
          league = Hash.new
          league["name"] = dm.name
          league["id"] = dm.id
          league["players"] = Array.new
          if battles.any?
            teams.each do |team|
              if team.active
                player = Hash.new
                player["name"] = team.player.name
                player["team"] = team.name
                player["id"] = team.id
                player["team_symbol"] = team.url_escudo_png
                player["details"] = Array.new
                player["points"] = 0
                player["diff_points"] = 0
                battles_team = battles.where("first_id = ? or second_id = ?", team.id, team.id)
                battles_team.each do |battle|
                  detail = Hash.new
                  detail["round"] = battle.round.number
                  detail["points"] = 0
                  detail["diff_points"] = 0
                  detail["opponent"] = opponent(battle, team, teams)
                  if battle.draw
                    player["points"] += 1
                    detail["points"] = 1
                  else
                    if (battle.first_id == team.id && battle.first_win) ||
                      ( battle.second_id == team.id && battle.second_win)
                      player["points"] += 3
                      detail["points"] = 3
                    end
                    detail["diff_points"] = battle.first_points + battle.second_points if detail["points"] == 3
                    player["diff_points"] += detail["diff_points"] if detail["points"] == 3
                  end
                  player["details"] << detail
                end
                player["diff_points"] = player["diff_points"].round(2)
                league["players"] << player
              end
            end
            league["players"].sort_by!{ |e| [e["points"], e["diff_points"]] }.reverse!
            leagues << league
          end
        end
        leagues.sort_by!{|l| l["id"]}.reverse!
        $redis.set("league", leagues.to_json)
      end
    end
  end
end
