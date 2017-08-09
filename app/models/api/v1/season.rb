module Api
  module V1
    class Season < ApplicationRecord
      has_many :dispute_months
      has_many :rounds
      has_many :scores, through: :rounds
      serialize :golden_rounds
      validates_presence_of :year

    end
  end
end
