module Api
  module V1
    class RoundsController < ApplicationController
      before_action :authenticate_user, except: %i[partials partial]
      before_action :set_round, only: %i[partial]

      def partials
        @partials = Round.partials
        render json: @partials
      end

      def partial
        @partial = Round.partial(params[:id])
        render json: @partial
      end

      # GET close_market_routines
      def closed_market_routines
        Round.closed_market_routines
        render json: { message: 'OK' }, status: :ok
      end

      # GET round_finished_routines
      def round_finished_routines
        Round.round_finished_routines
        render json: { message: 'OK' }, status: :ok
      end

      # GET general_tasks_routines
      def general_tasks_routines
        Round.general_tasks_routine
        render json: { message: 'OK' }, status: :ok
      end

      # GET active_rounds_progress
      def active_rounds_progress
        render json: { progress: Round.progress_active }, status: :ok
      end
    end
  end
end
