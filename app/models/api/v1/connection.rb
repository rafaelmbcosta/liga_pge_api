require 'net/http'
require 'open-uri'
module Api
  module V1
    # This class manages all connections with the official API
    class Connection
      STATUS_URL = 'https://api.cartolafc.globo.com/mercado/status'.freeze
      URL_TEAM_SCORE = 'https://api.cartolafc.globo.com/time/id/'.freeze
      TEAM_DATA = 'https://api.cartolafc.globo.com/times?q='.freeze
      ATHLETES_SCORES = 'https://api.cartolafc.globo.com/atletas/pontuados'.freeze

      def self.connect(uri)
        # For proxy development change coment lines below
        http = Net::HTTP::Proxy(ENV["proxy_name"], ENV["proxy_port"],
          ENV["proxy_user"], ENV["proxy_password"]) if Rails.env == "development"
        request = http.get_response(uri).body
        # request = Net::HTTP.get(uri)
        JSON.parse(request)
      end

      def self.market_open?(market_status)
        market_status['status_mercado'] == 1
      end

      def self.market_closed?(market_status)
        market_status['status_mercado'] == 2
      end

      def self.close_date(market_status)
        DateTime.new(market_status['fechamento']['ano'],
                     market_status['fechamento']['mes'],
                     market_status['fechamento']['dia'],
                     market_status['fechamento']['hora'],
                     market_status['fechamento']['minuto'])
      end

      def self.current_round
        market_status['rodada_atual']
      end

      def self.team_score(id, round = nil)
        raise ConnectionErrors::InvalidIdTag if id.nil?
        uri = URI(URL_TEAM_SCORE + id.to_s)
        uri = URI(URL_TEAM_SCORE + "#{id}/#{round}") unless round.nil?
        connect(uri)
      end

      def self.team_data(query)
        connect(URI(TEAM_DATA+query))
      end

      def self.market_status
        uri = URI(STATUS_URL)
        market = connect(uri)
        market['market_open'] = market_open?(market)
        market['market_closed'] = market_closed?(market)
        market['close_date'] = close_date(market)
        market
      end

      def self.athletes_scores
        uri = URI(ATHLETES_SCORES)
        connect(uri)
      end
    end
  end
end
