module Api
  module V1
    class PartialScore

      def perform
        last_round = Round.last
        teams = Team.where(season: last_round.season)
        teams.each do |team|
          # TODO
        end
      end
    end
  end
end
