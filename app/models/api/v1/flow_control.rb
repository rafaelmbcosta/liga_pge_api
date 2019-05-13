module Api
  module V1
    class FlowControl < ApplicationRecord
      enum message_type: { success: 0, error: 1 }
      before_save :set_time
      
      def set_time
        self.date = DateTime.now
      end
    end
  end
end