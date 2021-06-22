require 'active_support/concern'

module Concern::Score::ShowScores
  extend ActiveSupport::Concern

  included do
    def self.show_scores
      teams = Team.active
      months = []
      Season.active.dispute_months.each do |dm|
        dispute_month = { name: dm.name, id: dm.id }
        dispute_month[:players] = dispute_months_players(dm.scores, teams)
        months << dispute_month
      end
      result = order_dispute_months(months)
      $redis.set('scores', result.to_json)
      result
    end

    def self.dispute_months_players(scores, teams)
      players = []
      teams.each do |team|
        player = { name: team.player_name, team: team.name,
                   team_symbol: team.url_escudo_png }
        player[:details] = team_details(team, scores)
        player[:points] = player[:details].pluck(:points).sum
        players << player
      end
      order_players(players)
    end

    def self.order_dispute_months(array)
      array.sort_by { |hash| hash[:id] }.reverse!
    end

    def self.order_players(players)
      players.sort_by { |hash| hash[:points] }.reverse!
    end

    def self.team_details(team, scores)
      details = []
      team_scores = scores.where(team: team).order(:round_id)
      team_scores.each do |ts|
        details << { round: ts.round.number, points: ts.final_score }
      end
      details
    end
  end
end