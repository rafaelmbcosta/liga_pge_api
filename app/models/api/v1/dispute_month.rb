module Api
  module V1
    class DisputeMonth < ApplicationRecord
      belongs_to :season
      has_many :rounds
      has_many :scores, through: :rounds
      has_many :battles, through: :rounds
      has_many :month_activities
      has_many :currencies, through: :rounds
      has_many :awards
      serialize :dispute_rounds

      def self.scores
        $redis.get("scores")
      end

      def prize_pool
        total = 0
        active_players = self.month_activities.where(active: true, payed: true)
        return active_players.size * self.price
      end

      def golden_count
        (self.season.golden_rounds & self.dispute_rounds).count
      end

      def currency_prize
        prize_pool*0.0333
      end

      def active_players
        self.month_activities.where(active: true, payed: true)
      end

      def golden_prize
        # Total prize equals to 33.3 % of the total prize
        # divided by the ammount of golden rounds
        golden_prize_pool = prize_pool/3.0/golden_count# unless self.golden_count == 0
        return split_prizes(self.active_players, golden_prize_pool)
      end

      def monthly_prize
        # Total prize equals to 33.3 % of the total prize
        # divided by the ammount of golden rounds
        monthly_prize_pool = prize_pool/3.0
        # return monthly_prize_pool*0.5 , monthly_prize_pool*0.3, monthly_prize_pool*0.2
        return split_prizes(self.active_players, monthly_prize_pool)

      end

      def league_prize
        monthly_prize_pool = prize_pool*0.166666
        # return monthly_prize_pool*0.5 , monthly_prize_pool*0.3, monthly_prize_pool*0.2
        return split_prizes(self.active_players, monthly_prize_pool)
      end

      def self.battle_points
        $redis.get("league")
      end
    end
  end
end
