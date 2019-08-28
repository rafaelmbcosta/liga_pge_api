module Api
  module V1
    class CurrenciesController < ApplicationController
      before_action :authenticate_user, except: [:index]

      # GET /currencies
      def index
        @currencies = $redis.get('currencies')

        render json: @currencies
      end

      def rerun
        Currency.rerun_currencies
        render json: { mensagem: 'ok' }
      end
    end
  end
end
