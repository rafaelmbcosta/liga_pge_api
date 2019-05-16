module Api
  module V1
    class BattleWorker

      def self.create_battles
        Battle.create_battles
      end

      def self.perform
        create_battles
      end
    end
  end
end