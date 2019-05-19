module Api
  module V1
    class Score < ApplicationRecord
      belongs_to :team
      belongs_to :round

      # Create the scores for the round, as soon as market closes
      # same conditions to create battles
      def self.create_scores
        create_scores_rounds.each do |round|
          create_scores_round(round)
        end
        true
      rescue StandardError => e
        FlowControl.create(message_type: :error, message: e)
      end

      def self.create_scores_rounds
        Round.avaliable_for_score_generation
      end

      def self.create_scores_round(round)
        round.round_control.update_attributes(creating_scores: true)
        Team.active.each do |team|
          Score.create(team: team, round: round,
                       team_name: team.name,
                       player_name: team.player_name)
        end
        round.round_control.update_attributes(scores_created: true)
        true
      end
    end
  end
end
