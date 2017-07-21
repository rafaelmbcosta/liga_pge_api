module Api
  module V1
    class Battle < ApplicationRecord
      belongs_to :round
    end
  end
end
