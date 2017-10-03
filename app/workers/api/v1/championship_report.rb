module Api
  module V1
    class ChapionshipReport
      def self.format_award(results)
        return nil if results.empty?
        winners = []
        results.each do |result|

        end
      end

      def self.perform
        champions = Hash.new
        season = Season.last
        champions["first_turn"] = format_award(Award.where("season_id = ? and award_type = 3", season.id))
        champions["second_turn"] = format_award(Award.where("season_id = ? and award_type = 4", season.id))
        champions["championship"] = format_award(Award.where("season_id = ? and award_type = 0", season.id))
        $redis.set("championship_award", champions.to_json)
      end
    end
  end
end
