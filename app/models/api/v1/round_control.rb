module Api
  module V1
    class RoundControl < ApplicationRecord
      belongs_to :round
    end
  end
end
