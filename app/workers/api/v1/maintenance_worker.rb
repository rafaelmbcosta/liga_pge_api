module Api
  module V1
    class MaintenanceWorker
      def self.perform
        count = $redis.get('maintenance_count').to_i
        round = $redis.get('maintenance_round').to_i
        list = JSON.parse($redis.get("to_fix_#{round}"))
        if ( !list.empty? && count > 0 )
          round = Round.find(round)
          FinalScore.perform(round, true)
          $redis.set('maintenance_count', (count-1).to_s )
        end
      end
    end
  end
end
