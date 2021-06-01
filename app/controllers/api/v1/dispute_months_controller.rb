module Api
  module V1
    class DisputeMonthsController < ApplicationController
      def league_points
        @league_points = DisputeMonth.battle_points

        render json: @league_points
      end
    end
  end
end
