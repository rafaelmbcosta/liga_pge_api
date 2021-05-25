class ChampionshipReport
  def self.format_award(results)
    return nil if results.empty?
    winners = []
    results.sort_by{|x| x.position}.each do |result|
      winners << {
        :team_name => result.team.name,
        :position => result.position,
        :prize => result.prize,
        :team_symbol => result.team.url_escudo_png
      }
    end
    return winners
  end

  def self.perform
    champions = Hash.new
    season = Season.last
    champions["first_turn"] = format_award(Award.where("season_id = ? and award_type = 3", season.id))
    champions["second_turn"] = format_award(Award.where("season_id = ? and award_type = 4", season.id))
    champions["championship"] = format_award(Award.where("season_id = ? and award_type = 0", season.id))
    champions["active_now"] = ::Team.where(season: season, active: true).count
    $redis.set("championship_award", champions.to_json)
  end
end
