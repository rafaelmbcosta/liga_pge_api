module Api
  module V1
    class Player < ApplicationRecord
      has_many :teams

      def self.slug(name)
        I18n.transliterate(name).downcase.gsub(". ", "-").gsub(".","-").gsub(" ","-")
      end

      def self.search_player(name)
        team_slug = slug(name)
        market_status = Connection.market_status
        unless market_status["status_mercado"] ==  4
          (1..Api::V1::Round.last.number).to_a.each do |round_number|
            pontuacao = Connection.team_score(team_slug, round_number)
          end
        end
      end
    end
  end
end
