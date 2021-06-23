# Manages team scores
class Score < ApplicationRecord
  include Concern::Score::Sync
  include Concern::Score::UpdateScores
  include Concern::Score::ShowScores

  belongs_to :team
  belongs_to :round

  validates_uniqueness_of :round_id, scope: :team_id, message: 'Score ja cadastrado'

  def self.create_scores(round)
    Team.active.each do |team|
      Score.create!(team: team, round: round,
                    team_name: team.name,
                    player_name: team.player_name)
    end
    true
  end
end
