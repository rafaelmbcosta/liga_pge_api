module Api
  module V1
    class Season < ApplicationRecord
      has_many :dispute_months
      serialize :golden_rounds
      validates_presence_of :year

    end
  end
end
