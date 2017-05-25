module Api
  module V1
    class Team < ApplicationRecord
      belongs_to :season
      belongs_to :player
    end
  end
end
