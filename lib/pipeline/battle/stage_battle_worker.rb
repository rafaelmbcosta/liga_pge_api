module Pipeline
  module Battle
    class StageBattleWorker

      def initialize(input = {})
        @input = input
      end

      def executa(message)
        raise message.inspect
        params = {}
        BattleWorker.perform("closed_market")
        message
      end

    end
  end
end
