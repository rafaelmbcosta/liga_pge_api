module Api
  module V1
    class RoundWorker
      def self.check_new_round
        Round.check_new_round
      end

      def self.close_market
        Round.close_market
      end

      def self.finish_round
        Round.finish_round
      end

      def self.perform
        check_new_round
        close_market
        finish_round
      end
    end
  end
end
