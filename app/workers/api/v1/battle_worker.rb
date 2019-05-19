module Api
  module V1
    class BattleWorker

      def self.create_battles
        Battle.create_battles
      end

      # def self.update_generated_battles
      #   BattlesReport.perform
      # rescue StandardError => e
      #   FlowControl.create(message_type: :error, message: e)
      # end

      def self.perform(task)
        create_battles if task == "closed_market"

        # update_generated_battles if task == "round_finished"
      end
    end
  end
end