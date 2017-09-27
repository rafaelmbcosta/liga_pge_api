module Api
  module V1
    class Award < ApplicationRecord
      belongs_to :dispute_month
      belongs_to :team
      belongs_to :season
    end
  end
end
