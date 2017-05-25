module Api
  module V1
    class Player < ApplicationRecord
      has_many :teams
    end
  end
end
