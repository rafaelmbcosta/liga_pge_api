module Api
  module V1
    class DisputeMonthsController < ApplicationController
      before_action :authenticate_user, except: [:index, :league_points, :list]

      # GET /dispute_months
      def index
        @dispute_months = DisputeMonth.scores

        render json: @dispute_months
      end

      def list
        season = Season.active
        @dispute_months = DisputeMonth.where(season: season)

        render json: @dispute_months
      end

      def league_points
        @league_points = DisputeMonth.battle_points

        render json: @league_points
      end
    end
  end
end
