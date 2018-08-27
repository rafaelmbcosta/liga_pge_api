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
        self.dispute_months.collect{|dm| dm.prize_pool}.sum
      end

      def second_half_prize
        total = 0
        self.dispute_months.each do |dm|
          if dm.dispute_rounds.last >= 19
            # to get how many winners for this prize
            active_players = dm.month_activities.where(active: true)
            if ( dm.dispute_rounds.include?(19) and dm.dispute_rounds.index(19) + 1 <= dm.dispute_months.length/2 )
              total+= active_players.size * dm.price*0.083 * 0.5
            else
              total+= active_players.size * dm.price*0.083
            end
          end
        end
        # return total*0.5, total*0.3, total*0.2
        return split_prizes(active_players, total)
      end

      def first_half_prize
        total = 0
        active_players = nil
        dispute_months = self.dispute_months.order(:id)

        dispute_months.each do |dm|
          if dm.dispute_rounds.first <= 19
            # to get how many winners for this prize
            active_players = dm.month_activities.where(active: true)
            if (dm.dispute_rounds.include?(19) and dm.dispute_rounds.last != 19)
              total+= active_players.size * dm.price*0.083 * 0.5
            else
              total+= active_players.size * dm.price*0.083
            end
          end
          puts "Final: #{total}"
        end
        return split_prizes(active_players, total)
      end

      def championship_prize
        # pool is about 5 % of the total money
        # 50 % 30 % 20 for the first, second and third
        dm = self.dispute_months.last
        # to get how many winners for this prize
        active_players = dm.month_activities.where(active: true)
        championship_prize_pool = total_money*0.05
        return split_prizes(active_players, championship_prize_pool)
      end

      def cash
        payed_values = self.dispute_months
              .select("month_activities.payed_value")
              .joins(:month_activities)
              .where("month_activities.payed is true")
        received = payed_values.collect{ |value| value.payed_value }.sum

        prizes = self.dispute_months
              .select("awards.prize")
              .joins(:awards)
              .where("awards.payed is true")

        payed = prizes.collect{ |value| value.prize }.sum
        return received - payed
      end
    end
  end
end
