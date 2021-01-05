module Api
  module V1
    class BattlesController < ApplicationController
      before_action :authenticate_user, except: %i[index details]

      # GET /battles
      def index
        @battles = Battle.list_battles

        render json: @battles
      end

      def details
        @battles = Season.active.battles

        render json: @battles
      end
    end
  end
end
