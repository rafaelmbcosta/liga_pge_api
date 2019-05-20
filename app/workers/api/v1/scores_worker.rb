module Api
  module V1
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

      def self.perform(task)
        create_scores if task == "closed_market"
        if task == "finished_round"
          update_scores
          show_scores
        end
      end
    end
  end
end