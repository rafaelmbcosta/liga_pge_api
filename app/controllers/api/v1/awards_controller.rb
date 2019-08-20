module Api
  module V1
    class AwardsController < ApplicationController
      before_action :authenticate_user, except: [:championship, :monthly ]

      def championship
        @awards = $redis.get("championship_award")

        render json: @awards
      end

      def monthly
        @awards = $redis.get("monthly_awards")

        render json: @awards
      end
    end
  end
end
