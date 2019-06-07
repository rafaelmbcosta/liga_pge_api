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
        save_currencies
        show_currencies
      end
    end
  end
end