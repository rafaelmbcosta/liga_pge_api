#encoding:utf-8
require 'net/http'
require 'open-uri'
module Web
  module ApiCartola
    class Connection

      URL_TEAM_SCORE = "https://api.cartolafc.globo.com/time/slug/"
      # URL_TEAM_SCORE = "https://api.cartolafc.globo.com/time/slug/fabayern-fc/5"

      def self.get_team_score(slug, round=nil)
        uri = URI(URL_TEAM_SCORE + "#{slug}")
        uri = URI(URL_TEAM_SCORE + "#{slug}/#{round}") unless round.nil?

        # http = Net::HTTP::Proxy(@proxy_host, @proxy_port, @proxy_user, @proxy_pass)
        http = Net::HTTP::Proxy('proxy', '3128', 'fabi', 'passwd')
        request = http.get_response(uri)
        return request.body

      end
    end
  end
end
