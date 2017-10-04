#encoding:utf-8
require 'net/http'
require 'open-uri'
module Api
  module V1
    class Connection
      STATUS_URL = "https://api.cartolafc.globo.com/mercado/status"
      URL_TEAM_SCORE = "https://api.cartolafc.globo.com/time/slug/"
      ATHLETES_SCORES = "https://api.cartolafc.globo.com/atletas/pontuados"

      def self.connect(uri)
        request = Net::HTTP.get(uri)
        return JSON.parse(request)
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
