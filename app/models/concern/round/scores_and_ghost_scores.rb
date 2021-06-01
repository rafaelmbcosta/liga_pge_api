require 'active_support/concern'

module Concern::Round::ScoresAndGhostScores
  extend ActiveSupport::Concern

  included do
    # ok, this code is probably meant to be in battles or scores
    # putting here for now
  end
end

  # def team_score(team_id, scores)
  #   return ghost_score(scores) if team_id.nil?
  #   score = scores.find { |score| score.team_id ==  team_id }
  #   score.final_score
  # end

  # # ghost is represented by nil
  # # ghost battle is the one with first or second nil id
  # def find_ghost_battle
  #   self.battles.find { |battle| battle.first_id.nil? || battle.second_id.nil? }
  # end

  # # returns the score of the one facing the ghost
  # def ghost_buster_score(score_type, scores)
  #   ghost_battle = find_ghost_battle
  #   ghost_buster_id = ghost_battle.first_id.nil? ? ghost_battle.second_id : ghost_battle.first_id
  #   ghost_buster_team = Team.find(ghost_buster_id)
  #   ghost_buster_score = scores.find_by(team_id: ghost_buster_team.id)
  #   score_type == 'partial_score' ? ghost_buster_score.partial_score : ghost_buster_score.final_score
  # end

  # def sum_scores(score_type, scores)
  #   scores.pluck(score_type.to_sym).sum
  # end

  # def ghost_score(scores, partial = false)
  #   score = partial ? 'partial_score' : 'final_score'
  #   total_scores = scores.count - 1
  #   (sum_scores(score, scores) - ghost_buster_score(score, scores)) / total_scores
  # end