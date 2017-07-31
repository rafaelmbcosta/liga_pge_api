module Api
  module V1
    class BattleResults

      def self.team_score(team_id, scores, round)
        score = 0
        team_id.nil? ? score = ghost_score(round) : score = scores.find{|s| s.team_id == team_id}.final_score
        return score
      end

      def self.ghost_score(round)
        ghost_battle = Battle.find{|b| (b.first_id.nil? or b.second_id.nil?) and b.round_id == round.id}
        ghost_battle.first_id.nil? ? ghost_buster = Team.find(ghost_battle.second_id) : ghost_buster = Team.find(ghost_battle.first_id)
        ghost_buster_score = round.scores.find{|s| s.team_id == ghost_buster.id}.final_score
        ghost_score = (round.scores.sum(:final_score) - ghost_buster_score)/(round.scores.count -1)
        return ghost_score
      end

      def self.perform(round)
        battles = Battle.where(round_id: round.id)
        scores = round.scores
        battles.each do |battle|
          first_score = team_score(battle.first_id, scores, round)
          second_score = team_score(battle.second_id, scores, round)
          difference = (first_score - second_score).abs
          (difference > 5) ? draw = false : draw = true
          first_win = false
          second_win = false
          first_points = 0
          second_points = 0
          if !draw
            if first_score > second_score
              first_points = first_score - second_score
              first_win = true
            else
              second_points = second_score - first_score if first_score < second_score
              second_win = true
            end
          end
          battle.update_attributes(draw: draw, first_points: first_points, second_points: second_points, first_win: first_win, second_win: second_win)
        end
      end
    end
  end
end
