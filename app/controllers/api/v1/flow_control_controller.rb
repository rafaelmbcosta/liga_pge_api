module Api
  module V1
    class FlowControlController < ApplicationController
      before_action :authenticate_user

      def index
        @flow_control = FlowControl.all
        render json: @flow_control.last(10)
      end
    end
  end
end