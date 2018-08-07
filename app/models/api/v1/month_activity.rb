module Api
  module V1
    class MonthActivity < ApplicationRecord
      belongs_to :team
      belongs_to :dispute_month

      def pay(value)
        self.payed_value = value
        self.save
      end
    end
  end
end
