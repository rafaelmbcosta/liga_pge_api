# Generate team battles every round
class Battle < ApplicationRecord
  include Concern::Battle::ShowLeague
  include Concern::Battle::Sync
  include Concern::Battle::Creation
  include Concern::Battle::ShowBattles

  belongs_to :round

  scope :find_battle, lambda { |round, team, other_team|
    where(round: round).where('first_id = ? and second_id = ?', team, other_team)
  }

  def self.rounds_avaliable_for_battles
    Round.avaliable_for_battles
  end

  def first_victory(team_id)
    first_id == team_id && first_win
  end

  def second_victory(team_id)
    second_id == team_id && second_win
  end

  def team_victory(team)
    first_victory(team.id) || second_victory(team.id)
  end

  def team_difference_points
    (first_points - second_points).abs
  end

  def self.list_battles
    $redis.get('battles')
  end

  def self.draw?(first_score, second_score)
    difference = (first_score - second_score).abs
    !(difference > 5)
  end

  def check_winner(first_score, second_score)
    return [false, 0] if draw || second_score > first_score

    [true, first_score - second_score]
  end

  # Update battle attributes
  def battle_results(scores, round)
    first_score = round.team_score(first_id, scores)
    second_score = round.team_score(second_id, scores)
    self.draw = Battle.draw?(first_score, second_score)
    self.first_win, self.first_points = check_winner(first_score, second_score)
    self.second_win, self.second_points = check_winner(second_score, first_score)
    save!
  end

  # check team scores and update winners / losers / draws
  def self.update_battle_scores_round(round)
    scores = round.scores
    round.battles.each do |battle|
      battle.battle_results(scores, round)
    end
    true
  end

  def self.rerun_battles(this_dispute_month = false)
    rounds = Round.season_finished_rounds(this_dispute_month)
    rounds.each do |round|
      update_battle_scores_round(round)
    end
  end

  # Gotta iterate through rounds so i can flag them
  def self.update_battle_scores
    Round.rounds_with_battles_to_update.each do |round|
      round.round_control.update_attributes(updating_battle_scores: true)
      update_battle_scores_round(round)
      round.round_control.update_attributes(battle_scores_updated: true)
    end
    true
  end
end
