module Api
  module V1
    class DisputeMonth < ApplicationRecord
      belongs_to :season
      has_many :rounds
      has_many :scores, through: :rounds
      has_many :battles, through: :rounds
      serialize :dispute_rounds

      def self.scores
        $redis.get("scores")
      end

      def self.battle_points
        $redis.get("league")
      end
    end
  end
end
