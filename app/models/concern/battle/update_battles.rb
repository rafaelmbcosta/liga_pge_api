module Concern::Battle::UpdateBattles
  extend ActiveSupport::Concern

  included do
    def self.update_battle_scores(round)
      round.battles.each do |battle|
        battle.battle_results
      end
      true
    end

    def battle_results
      scores = round.scores
      first_score = team_score(first_id, scores, round)
      second_score = team_score(second_id, scores, round)
      self.draw = draw?(first_score, second_score)
      self.first_win, self.first_points = check_winner(first_score, second_score)
      self.second_win, self.second_points = check_winner(second_score, first_score)
      save!
    end

    def team_score(team_id, scores, round)
      return ghost_score(scores, round) if team_id.nil?

      score = scores.find { |score| score.team_id ==  team_id }
      score.final_score
    end

    # the ghost score is the average scores without the one facing the ghost
    def ghost_score(scores, round)
      score = scores.pluck(:final_score).sum
      total_scores = scores.size - 1

      (score - ghost_buster_score(scores, round)) / total_scores
    end

    def ghost_buster_score(scores, round)
      ghost_battle = round.battles.find { |battle| battle.first_id.nil? || battle.second_id.nil? }
      ghost_buster_id = ghost_battle.first_id.nil? ? ghost_battle.second_id : ghost_battle.first_id
      ghost_buster_team = Team.find(ghost_buster_id)
      ghost_buster_score = scores.to_a.find { |score| score.team_id == ghost_buster_team.id }
      raise 'Oponente do Fantasma não encontrado' if ghost_buster_score.nil?

      ghost_buster_score.final_score
    end

    def draw?(first_score, second_score)
      difference = (first_score - second_score).abs
      difference <= 5
    end

    def check_winner(first_score, second_score)
      return [false, 0] if draw || second_score > first_score

      [true, first_score - second_score]
    end
  end
end