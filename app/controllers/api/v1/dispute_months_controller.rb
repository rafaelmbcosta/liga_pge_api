module Api
  module V1
    class DisputeMonthsController < ApplicationController
      before_action :authenticate_user, except: [ :index, :league_points]

      # GET /dispute_months
      def index
        @dispute_months = DisputeMonth.scores

        render json: @dispute_months
      end

      def active_rounds
        DisputeMonth.active_rounds
      rescue SeasonErrors::NoActiveSeasonError => e
        render json: { error: e.message }, status: :internal_server_error
      end

      def league_points
        @league_points = DisputeMonth.battle_points

        render json: @league_points
      end
    end
  end
end
