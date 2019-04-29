module Api
  module V1
    class RoundWorker
      def self.check_new_round
        Round.check_new_round
      end

      def self.perform
        check_new_round
      end
    end
  end
end
