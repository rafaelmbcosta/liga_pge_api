require 'active_support/concern'

module Concern::Score::UpdateScores
  extend ActiveSupport::Concern

  included do
    def self.update_scores(round)
      Team.active.each do |team|
        update_team_scores(round, team)
      end
      true
    end

    def self.update_team_scores(round, team)
      api_scores = Connection.team_score(team.id_tag, round.number)
      raise 'Invalid API Scores' if api_scores.nil? || !api_scores.include?('pontos')

      score = Score.find_by(round: round, team: team)
      score.update(final_score: api_scores['pontos'].round(2)) if score.present?
    end
  end
end