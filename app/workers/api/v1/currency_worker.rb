module Api
  module V1
    class CurrencyWorker

      def self.save_currencies
        Currency.save_currencies
      end

      def self.show_currencies
        Currency.show_currencies
      end

      def self.perform
        # Api::V1::Currency(id: integer, value: float, team_id: integer, round_id: integer, difference: float, created_at: datetime, updated_at: datetime) 

        save_currencies
        show_currencies
      end
    end
  end
end