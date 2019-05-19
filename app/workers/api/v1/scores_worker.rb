module Api
  module V1
    class ScoresWorker
      def self.create_scores
        Score.create_scores
      end

      def self.perform(task)
        create_scores if task == "closed_market"
      end
    end
  end
end