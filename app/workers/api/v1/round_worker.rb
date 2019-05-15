module Api
  module V1
    class RoundWorker
      def self.check_new_round
        Round.check_new_round
      end

      def self.close_market
        Round.close_market
      end

      def self.perform
        check_new_round
        close_market
      end
    end
  end
end
