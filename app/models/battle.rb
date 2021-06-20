# Generate team battles every round
class Battle < ApplicationRecord
  include Concern::Battle::ShowLeague
  include Concern::Battle::Sync
  include Concern::Battle::Creation

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

  def self.battles_to_be_shown
    Battle.where(round_id: Season.active.rounds.pluck(:id))
          .group_by(&:round_id)
  end

  def self.battle_report(battle_group, teams)
    report = []
    battle_group.each do |round_id, battles|
      list = {}
      round = Round.find(round_id)
      list[:round] = round.number
      list[:battles] = show_list_battles(teams, battles)
      report << list
    end
    report
  end

  def self.order_battle_report(battle_report)
    battle_report.sort_by { |list| list[:round] }.reverse
  end

  def self.show_battles
    # PROFILE THIS!
    teams = Team.all
    battle_group = battles_to_be_shown
    battle_report = battle_report(battle_group, teams)
    battle_report = order_battle_report(battle_report)
    $redis.set('battles', order_battle_report(battle_report).to_json)
    battle_report
  end

  def self.show_list_battles(teams, battles)
    data = []
    battles.each do |battle|
      data << show_battle_data(battle, teams)
    end
    data
  end

  def self.battle_team_details(team_id, teams)
    return ['Fantasma', ''] if team_id.nil?

    team = teams.find { |t| t.id == team_id }
    name = "#{team.player_name} ( #{team.name} )"
    symbol = team.url_escudo_png
    [name, symbol]
  end

  def self.show_battle_data(battle, teams)
    first_name, first_symbol = battle_team_details(battle.first_id, teams)
    second_name, second_symbol = battle_team_details(battle.second_id, teams)
    { first_name: first_name, second_name: second_name,
      first_team_symbol: first_symbol, second_team_symbol: second_symbol }
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
