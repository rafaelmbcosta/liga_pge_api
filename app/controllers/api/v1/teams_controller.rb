module Api
  module V1
    # Team management
    class TeamsController < ApplicationController
      before_action :authenticate_user


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
