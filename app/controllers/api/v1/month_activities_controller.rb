module Api
  module V1
    class MonthActivitiesController < ApplicationController
      before_action :set_month_activity, only: [:show, :update, :destroy]

      # GET /month_activities
      def index
        @month_activities = MonthActivity.all

        render json: @month_activities
      end

      # GET /month_activities/1
      def show
        render json: @month_activity
      end

      # POST /month_activities
      def create
        @month_activity = MonthActivity.new(month_activity_params)

        if @month_activity.save
          render json: @month_activity, status: :created, location: @month_activity
        else
          render json: @month_activity.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /month_activities/1
      def update
        if @month_activity.update(month_activity_params)
          render json: @month_activity
        else
          render json: @month_activity.errors, status: :unprocessable_entity
        end
      end

      # DELETE /month_activities/1
      def destroy
        @month_activity.destroy
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_month_activity
          @month_activity = MonthActivity.find(params[:id])
        end

        # Only allow a trusted parameter "white list" through.
        def month_activity_params
          params.require(:month_activity).permit(:team_id, :dispute_month_id, :active)
        end
    end
  end
end
