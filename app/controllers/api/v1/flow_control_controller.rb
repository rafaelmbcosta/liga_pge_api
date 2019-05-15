module Api
  module V1
    class FlowControlController < ApplicationController
      def index
        @flow_control = FlowControl.all
        render json: @flow_control
      end
    end
  end
end