module Api
  module V1
    class SeasonsController < ApplicationController
      before_action :authenticate_user, except: [ :index, :scores]
      before_action :set_season, only: [:show, :update, :destroy]

      # GET /seasons
      def index
        @seasons = Season.all

        render json: @seasons
      end

      # GET /seasons/1
      def show
        render json: @season
      end

      def scores
        @season_scores = $redis.get("season_scores")
        render json: @season_scores
      end

      # POST /seasons
      def create
        @season = Season.new(season_params)

        if @season.save
          render json: @season, status: :created, location: @season
        else
          render json: @season.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /seasons/1
      def update
        if @season.update(season_params)
          render json: @season
        else
          render json: @season.errors, status: :unprocessable_entity
        end
      end

      # DELETE /seasons/1
      def destroy
        @season.destroy
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_season
          @season = Season.find(params[:id])
        end

        # Only allow a trusted parameter "white list" through.
        def season_params
          params.require(:season).permit(:year, :finished)
        end
    end
  end
end
