module Api
  module V1
    class BattleWorker

      def self.create_battles
        Battle.create_battles
      end

      def update_generated_battles
        BattlesReport.perform
      rescue StandardError => e
        FlowControl.create(message_type: :error, message: e)
      end

      def self.perform
        create_battles
        update_generated_battles
      end
    end
  end
end