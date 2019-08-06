module Api
  module V1
    # Team management
    class TeamsController < ApplicationController
      before_action :authenticate_user
      before_action :set_team, only: %i[show update destroy]

      # GET /teams
      def index
        @teams = Team.all

        render json: @teams
      end

      # GET /teams/1
      def show
        render json: @team, include: %i[season player]
      end

      # POST /teams
      def create
        @team = Team.new(team_params)

        if @team.save
          render json: @team, status: :created, location: @team
        else
          render json: @team.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /teams/1
      def update
        if @team.update(team_params)
          render json: @team
        else
          render json: @team.errors, status: :unprocessable_entity
        end
      end

      # DELETE /teams/1
      def destroy
        @team.destroy
      end

      def activation
        team = Team.activation(team_params)
        if team[:success]
          render json: team, status: :ok
        else
          render json: team, status: :unprocessable_entity
        end
      end

      def find_team
        query = Connection.team_data(search_params[:q])
        render json: query, status: :ok
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_team
        @team = Team.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def team_params
        params.require(:team).permit(:name, :season_id, :id, :active, :slug,
                                     :url_escudo_png, :player_name, :id_tag)
      end

      def search_params
        params.require(:search).permit(:q)
      end
    end
  end
end
