module Api
  module V1
    class MonthActivity < ApplicationRecord
      belongs_to :team
      belongs_to :dispute_month
    end
  end
end
