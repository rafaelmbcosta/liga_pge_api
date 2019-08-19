module Api
  module V1
    module Concerns
      module Season
        # Methods concerning turns and championship scores
        module TurnsAndChampionship
          extend ActiveSupport::Concern

          included do
            def self.turns_and_championship
              season = Api::V1::Season.active
              teams = Api::V1::Team.all
              
            end
          end
        end
      end
    end
  end
end
