module Api
  module V1
    module Concerns
      module Battle
        # Methods concerning league show
        module ShowLeague
          extend ActiveSupport::Concern

          included do
            def self.dispute_month_league_report(dm, teams)
              league = { name: dm.name, id: dm.id, players: [] }
              league[:players] = league_report_teams(teams, dm.battles) if dm.battles.any?
              league
            end

            def self.opponent(battle, team, teams)
              opponent_id = battle.first_id == team.id ? battle.second_id : battle.first_id
              return opponent_id.nil? ? 'Fantasma' : "#{teams.find(opponent_id).name}"
            end

            def self.league_battle_result(battle, team)
              return [1, 0] if battle.draw
              first_diff = battle.first_points - battle.second_points
              return [3, first_diff] if battle.first_win && battle.first_id == team.id
              second_diff = battle.second_points - battle.first_points
              return [3, second_diff] if battle.second_win && battle.second_id == team.id
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
              details
            end

            def self.league_report_teams(battles, teams)
              report_teams = []
              teams.active.each do |team|
                team_battles = battles.select { |battle| battle.first_id == team.id || 
                                                         battle.second_id == team.id }
                team_details = league_team_details(teams, team, team_battles)
                data = { name: team.player_name, team: team.name, id: id,
                         team_symbol: team.url_escudo_png, details: team_details,
                         points: team_details.pluck(:points).sum,
                        diff_points: team_details.pluck(:diff_points).sum }
                report_teams << data
              end
              report_teams
            end

            # pending: order league result / test
            def self.show_league
              # find season
              season = Season.active
              teams = Team.all
              # find dispute_months
              league_report = []
              season.dispute_months.each do |dispute_month|
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