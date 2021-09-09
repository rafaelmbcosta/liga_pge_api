module Api
  module V1
    class DisputeMonthsController < ApplicationController
      def index
        @dispute_months = DisputeMonth.scores

        render json: @dispute_months
      end

      def list
        @dispute_months = Season.active.dispute_months

        render json: @dispute_months
      end

      def league_points
        @league_points = DisputeMonth.battle_points

        render json: @league_points
      end
    end
  end
end
