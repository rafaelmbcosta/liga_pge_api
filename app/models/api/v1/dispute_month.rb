module Api
  module V1
    class DisputeMonth < ApplicationRecord
      belongs_to :season
      has_many :rounds
      has_many :scores, through: :rounds
      has_many :battles, through: :rounds
      has_many :month_activities
      serialize :dispute_rounds

      def self.scores
        $redis.get("scores")
      end

      def golden_count
        self.month_activities.where("active is true and payed is true").count
      end

      def golden_prize
        # Total prize equals to 33.3 % of the total prize
        # divided by the ammount of golden rounds
        golden_prize_pool = self.season.total_money/3.0/self.golden_count unless self.golden_count == 0
        return golden_prize_pool*0.5 , golden_prize_pool*0.3, golden_prize_pool*0.2
      end

      def self.battle_points
        $redis.get("league")
      end
    end
  end
end
