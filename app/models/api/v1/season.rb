module Api
  module V1
    class Season < ApplicationRecord
      has_many :dispute_months
      has_many :rounds
      has_many :scores, through: :rounds
      serialize :golden_rounds
      validates_presence_of :year

      def total_money
        total = 0
        self.dispute_months.each do |dm|
          active_players = dm.month_activities.where(active: true, payed: true)
          total+= active_players.size * dm.price
        end
        return total
      end

      def second_half_prize
        total = 0
        self.dispute_months.each do |dm|
          if dm.dispute_rounds.last >= 19
            active_players = dm.month_activities.where(active: true, payed: true)
            if (dm.dispute_rounds.include?(19) and dm.dispute_rounds.last != 19)
              total+= active_players.size * dm.price*0.083 * 0.5
            else
              total+= active_players.size * dm.price*0.083
            end
          end
        end
        return total*0.5, total*0.3, total*0.2
      end

      def first_half_prize
        total = 0
        self.dispute_months.each do |dm|
          if dm.dispute_rounds.first <= 19
            active_players = dm.month_activities.where(active: true, payed: true)
            if (dm.dispute_rounds.include?(19) and dm.dispute_rounds.last == 19)
              total+= active_players.size * dm.price*0.083
            else
              total+= active_players.size * dm.price*0.083 * 0.5
            end
          end
        end
        return total*0.5, total*0.3, total*0.2
      end

      def championship_prize
        # pool is about 5 % of the total money
        # 50 % 30 % 20 for the first, second and third
        championship_prize_pool = total_money*0.05
        return championship_prize_pool*0.5, championship_prize_pool*0.3, championship_prize_pool*0.2
      end
    end
  end
end
