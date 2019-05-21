module Api
  module V1
    # Implement some jobs according to the flow
    class ScoresWorker
      def self.create_scores
        Score.create_scores
      end

      def self.update_scores
        Score.update_scores
      end

      def self.show_scores
        Score.show_scores
      end

      def self.closed_market_jobs
        create_scores
      end

      def self.round_finished_jobs
        update_scores
        show_scores
      end

      def self.perform(task)
        closed_market_jobs if task == 'closed_market'
        round_finished_jobs if task == 'finished_round'
      end
    end
  end
end