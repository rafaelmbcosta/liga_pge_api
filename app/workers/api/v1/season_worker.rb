module Api
  module V1
    class SeasonWorker

      def self.season_year(conn)
        conn["temporada"]
      end

      def self.open_market?(conn)
        conn["status_mercado"] == 1 ? true : false
      end

      # Creates a new season if there is no current
      def self.perform
        connection = Connection.market_status
        Season.create(year: year, finished: false) if (Season.current.nil? && open_market?(conn))
      end
    end
  end
end
