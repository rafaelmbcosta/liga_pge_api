module Api
  module V1
    class DisputeMonth < ApplicationRecord
      belongs_to :season
      has_many :rounds
      serialize :dispute_rounds
    end
  end
end
