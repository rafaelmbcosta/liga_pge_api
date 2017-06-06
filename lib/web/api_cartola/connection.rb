#encoding:utf-8
require 'net/http'
module Web
  module ApiCartola
    class Connection

      URL_TEAM_SCORE = 'https://api.cartolafc.globo.com/time/slug/'

      def self.get_team_score(slug, round)
        uri = URI(URL_TEAM_SCORE + slug + '/' + round)
        return Net::HTTP.get(uri)
      end

    end
  end
end
