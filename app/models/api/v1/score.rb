module Api
  module V1
    class Score < ApplicationRecord
      belongs_to :team
      belongs_to :round
    end
  end
end
