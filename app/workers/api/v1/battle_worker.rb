module Api
  module V1
    class BattleWorker

      def self.create_battles
        Battle.create_battles
      end

      def self.show_battles
        Battle.show_battles
      end

      def self.show_league_scores

      end

      def self.update_generated_battles
        Battle.update_battle_scores
      end

      def self.closed_market_tasks
        create_battles
        show_battles
      end

      def self.round_finished_tasks
        update_generated_battles
        show_league_scores
      end

      def self.perform(task)
        closed_market_tasks if task == "closed_market"
        round_finished_tasks if task == "finished_round"
      end
    end
  end
end