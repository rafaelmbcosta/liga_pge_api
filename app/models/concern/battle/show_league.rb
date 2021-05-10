module Api
  module V1
    module Concern
      module Battle
        # Methods concerning league show
        module ShowLeague
          extend ActiveSupport::Concern

          included do
            # returns the league report for each dispute month
            def self.dispute_month_league_report(dispute, teams)
              league = { name: dispute.name, id: dispute.id, players: [] }
              report = league_report_teams(dispute.battles, teams) if dispute.battles.any?
              league[:players] = sort_league_report(report)
              league
            end

            # find the opponent name or return 'ghost'
            def self.opponent(battle, team, teams)
              opponent_id = battle.first_id == team.id ? battle.second_id : battle.first_id
              return 'Fantasma' if opponent_id.nil?

              teams.find(opponent_id).name.to_s
            end

            def self.check_victory(battle, team)
              victory = battle.team_victory(team)
              difference_points = battle.team_difference_points
              return [true, [3, difference_points]] if victory

              [false, []]
            end

            def self.league_battle_result(battle, team)
              return [1, 0] if battle.draw

              victory, point_array = check_victory(battle, team)
              return point_array if victory

              [0, 0]
            end

            def self.team_details(teams, team, battles)
              team_details = []
              battles.each do |battle|
                details = { round: battle.round.number, points: 0,
                            diff_points: 0, opponent: opponent(battle, team, teams) }
                details[:points], details[:diff_points] = league_battle_result(battle, team)
                team_details << details
              end
              team_details
            end

            def self.league_report_data(team, team_details)
              { name: team.player_name, team: team.name, id: team.id,
                team_symbol: team.url_escudo_png, details: team_details,
                points: team_details.pluck(:points).sum.round(2),
                diff_points: team_details.pluck(:diff_points).sum.round(2) }
            end

            def self.sort_league_report(report)
              return [] if report.nil?

              report.sort_by { |player| [player[:points], player[:diff_points]] }.reverse
            end

            def self.league_report_teams(battles, teams)
              report_teams = []
              teams.select(&:active).each do |team|
                team_battles = battles.select do |battle|
                  battle.first_id == team.id || battle.second_id == team.id
                end
                team_details = team_details(teams, team, team_battles)
                report_teams << league_report_data(team, team_details)
              end
              report_teams
            end

            # pending: order league result / test
            def self.show_league
              # find season
              season = Season.active
              teams = ::Team.all
              # find dispute_months
              league_report = []
              season.dispute_months.reverse.each do |dispute_month|
                league_report << dispute_month_league_report(dispute_month, teams)
              end
              # go through league dispute_month
              $redis.set('league', league_report.to_json)
              league_report
            end
          end
        end
      end
    end
  end
end
