module Api
  module V1
    class SeasonWorker

      def self.season_year(conn)
        conn["temporada"]
      end

      def self.open_market?(conn)
        conn["status_mercado"] == 1 ? true : false
      end

      def self.create_season
        connection = Connection.market_status
        Season.create(year: year, finished: false) if (Season.active.nil? && open_market?(conn))
      end

      def self.turns_and_championship
        Season.turns_and_championship
      end

      # Creates a new season if there is no current
      def self.perform(status)
        turns_and_championship if status == "finished_round"
      end
    end
  end
end
