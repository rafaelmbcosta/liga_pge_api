module Concern::Battle::ShowBattles
  extend ActiveSupport::Concern

  included do
    def self.show_battles
      teams = Team.all
      battle_group = battles_to_be_shown
      battle_report = battle_report(battle_group, teams)
      battle_report = order_battle_report(battle_report)
      $redis.set('battles', battle_report.to_json)
      battle_report
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

    def self.show_list_battles(teams, battles)
      data = []
      battles.each do |battle|
        data << show_battle_data(battle, teams)
      end
      data
    end

    def self.show_battle_data(battle, teams)
      first_name, first_symbol = battle_team_details(battle.first_id, teams)
      second_name, second_symbol = battle_team_details(battle.second_id, teams)
      { first_name: first_name, second_name: second_name,
        first_team_symbol: first_symbol, second_team_symbol: second_symbol }
    end

    def self.battle_team_details(team_id, teams)
      return ['Fantasma', ''] if team_id.nil?

      team = teams.find { |t| t.id == team_id }
      name = "#{team.player_name} ( #{team.name} )"
      symbol = team.url_escudo_png
      [name, symbol]
    end
  end
end
