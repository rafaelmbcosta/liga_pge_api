module Api
  module V1
    class DisputeMonth < ApplicationRecord
      belongs_to :season
      has_many :rounds
      has_many :scores, through: :rounds
      has_many :battles, through: :rounds
      serialize :dispute_rounds

      def self.scores
        dispute_months = DisputeMonth.all
        teams = Team.where(active: true)
        months = []
        dispute_months.each do |dm|
          scores = dm.scores
          month = Hash.new
          month["name"] = dm.name
          month["players"] = Array.new
          if scores.any?
            teams.each do |team|
              player = Hash.new
              player["name"] = team.player.name
              player["team"] = team.name
              player["points"] = 0
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
        return months
      end

      def self.battle_points
        dispute_months = DisputeMonth.all
        teams = Team.where(active: true)
        leagues = []
        dispute_months.each do |dm|
          battles = dm.battles
          league = Hash.new
          league["name"] = dm.name
          league["players"] = Array.new
          if battles.any?
            teams.each do |team|
              player = Hash.new
              player["name"] = team.player.name
              player["team"] = team.name
              player["details"] = Array.new
              player["points"] = 0
              player["diff_points"] = 0
              battles_team = battles.where("first_id = ? or second_id = ?", team.id, team.id)
              battles_team.each do |battle|
                detail = Hash.new
                detail["round"] = battle.round.number
                detail["points"] = 0
                if battle.draw
                  player["points"] += 1
                  detail["points"] = 1
                else
                  if (battle.first_id == team.id && battle.first_win) ||
                    ( battle.second_id == team.id && battle.second_win)
                    player["points"] += 3
                    detail["points"] = 3
                  end
                  player["diff_points"] += battle.first_points + battle.second_points if detail["points"] == 3
                end
                player["details"] << detail
              end
              player["diff_points"] = player["diff_points"].round(2)
              league["players"] << player
            end
            league["players"].sort_by!{ |e| [e["points"], e["diff_points"]] }.reverse!
            leagues << league
          end
        end
        return leagues
      end
    end
  end
end
