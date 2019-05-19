module Api
  module V1
    class ScoresWorker

      def self.perform
        Score.create_scores
      end
    end
  end
end