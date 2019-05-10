module Api
  module V1
    class TeamWorker
      def self.perform
        Team.where(season: Season.active).each do |team|
          team_data = Connection.team_score(team.slug)
          raise "ERRO TEAM ID: #{team.id}, SLUG: (#{team.slug})" if team_data.nil?
          team.update_attributes(url_escudo_png: team_data["time"]["url_escudo_svg"])
        end
      end
    end
  end
end
