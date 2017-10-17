module Api
  module V1
    class TeamWorker
      def self.perform
        Team.all.each do |team|
          team.update_attributes(url_escudo_png: Connection.team_score(team.slug)["time"]["url_escudo_svg"])
        end
      end
    end
  end
end
