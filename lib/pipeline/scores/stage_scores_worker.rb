module Pipeline
  module Scores
    class StageScoresWorker

      def initialize(input = {})
        @input = input
      end

      def executa(message)
        params = {}
        ScoresWorkerer.perform("closed_market")
        message
      end
    end
  end
end
