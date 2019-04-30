#encoding:utf-8
require 'net/http'
require 'open-uri'
module Api
  module V1
    class Connection
      STATUS_URL = 'https://api.cartolafc.globo.com/mercado/status'.freeze
      URL_TEAM_SCORE = 'https://api.cartolafc.globo.com/time/slug/'.freeze
      ATHLETES_SCORES = 'https://api.cartolafc.globo.com/atletas/pontuados'.freeze

      def self.connect(uri)
        # For proxy development change coment lines below
        # http = Net::HTTP::Proxy(ENV["proxy_name"], ENV["proxy_port"],
        #   ENV["proxy_user"], ENV["proxy_password"]) if Rails.env == "development"
        # request = http.get_response(uri).body
        request = Net::HTTP.get(uri)
        return JSON.parse(request)
      end

      def self.market_open?
        market_status["status_mercado"] == 1
      end

      def self.market_closed?
        market_status["status_mercado"] == 2
      end

      def self.current_round
        market_status["rodada_atual"]
      end

      def self.team_score(slug, round=nil)
        uri = URI(URL_TEAM_SCORE + "#{slug}")
        uri = URI(URL_TEAM_SCORE + "#{slug}/#{round}") unless round.nil?
        return connect(uri)
      end

      def self.market_status
        uri = URI(STATUS_URL)
        return connect(uri)
      end

      def self.athletes_scores
        uri = URI(ATHLETES_SCORES)
        return connect(uri)
      end
    end
  end
end
