module Api
  module V1
    class DisputeMonth < ApplicationRecord
      belongs_to :season
      serialize :dispute_rounds
    end
  end
end
