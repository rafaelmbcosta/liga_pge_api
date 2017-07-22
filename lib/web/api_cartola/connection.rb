#encoding:utf-8
require 'net/http'
require 'open-uri'
module Web
  module ApiCartola
    class Connection
      STATUS_URL = "https://api.cartolafc.globo.com/mercado/status"
      URL_TEAM_SCORE = "https://api.cartolafc.globo.com/time/slug/"

      def self.connect(uri)
        http = Net::HTTP::Proxy(ENV["proxy_name"], ENV["proxy_port"],
          ENV["proxy_user"], ENV["proxy_password"]) if Rails.env == "development"
        request = http.get_response(uri)
        return JSON.parse(request.body)
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
    end
  end
end
