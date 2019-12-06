module Api
  module V1
    module Concerns
      module Season
        # Methods concerning turns and championship scores
        module TurnsAndChampionship
          extend ActiveSupport::Concern

          RANGE_DATA = [
            { title: 'Primeiro Turno', range: 1..19 },
            { title: 'Segundo Turno', range: 20..38 },
            { title: 'Campeonato', range: 1..38 }
          ].freeze

          included do
            def self.turns_and_championship
              season = Api::V1::Season.active
              teams = Api::V1::Team.all
              season_scores = []
              RANGE_DATA.each do |data|
                season_scores << range_scores(data, teams, season.scores)
              end
              $redis.set('season_scores', season_scores.to_json)
            end

            def self.range_scores(data, teams, scores)
              # filter the rounds that belong to that range
              scores_range = scores.select { |score| data[:range].to_a.include?(score.round.number) }
              return { title: data[:title], scores: [] } if scores_range.empty?

              { title: data[:title], scores: team_score_data(scores_range, teams) }
            end

            def self.team_score_data(scores, teams)
              score_array = []
              team_points = scores.group_by(&:team_id)
              team_points.each do |team_id, team_scores|
                team = teams.find { |t| t.id == team_id }
                score_array << {
                  team_id: team_id, team_name: team.name, player_name: team.player_name,
                  season_score: team_scores.sum(&:final_score), team_symbol: team.url_escudo_png
                }
              end
              score_array.sort_by { |hash| hash[:season_score] } .reverse!
            end
          end
        end
      end
    end
  end
end
