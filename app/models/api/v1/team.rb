module Api
  module V1
    class Team < ApplicationRecord
      belongs_to :season
      belongs_to :player
      has_many :currencies
    end
  end
end
