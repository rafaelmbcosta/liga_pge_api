module Api
  module V1
    class BattlesReport

      def self.team_name(id, teams)
        name = ""
        if id.nil?
          name = "Fantasma"
        else
          team = teams.find{|t| t.id == id}
          name = "#{team.player.name} ( #{team.name} )"
        end
      end

      def self.team_symbol(id, teams)
        symbol = ""
        unless id.nil?
          team = teams.find{|t| t.id == id}
          symbol = team.url_escudo_png
        end
        return symbol
      end

      def self.perform
        season = Season.active
        teams = Team.where(season: season)
        battles = Battle.where(id: season.rounds.pluck(:id)).group_by(&:round_id)
        full_list = []
        battles.each do |k,v|
          list = Hash.new
          round = Round.find(k)
          list["round"] = round.number
          list["battles"] = Array.new
          v.each do |battle|
            list_battle = battle.attributes
            list_battle["first_name"] = team_name(battle.first_id, teams)
            list_battle["second_name"] = team_name(battle.second_id, teams)
            list_battle["first_team_symbol"] = team_symbol(battle.first_id, teams)
            list_battle["second_team_symbol"] = team_symbol(battle.second_id, teams)
            list["battles"] << list_battle
          end
          full_list << list
        end
        $redis.set("battles", full_list.sort_by{|list| list["round"]}.reverse.to_json)
      end
    end
  end
end
