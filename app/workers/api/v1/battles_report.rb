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

      def self.perform
        teams = Team.all
        battles = Battle.all.group_by(&:round_id)
        full_list = []
        battles.each do |k,v|
          list = Hash.new
          list["round"] = Round.find(k).number
          list["battles"] = Array.new
          v.each do |battle|
            list_battle = battle.attributes
            list_battle["first_name"] = team_name(battle.first_id, teams)
            list_battle["second_name"] = team_name(battle.second_id, teams)
            list["battles"] << list_battle
          end
          full_list << list
        end
        $redis.set("battles", full_list.sort_by{|list| list["round"]}.reverse.to_json)
      end
    end
  end
end
