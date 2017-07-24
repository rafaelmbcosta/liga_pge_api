module Api
  module V1
    class BattleResult

      def self.perform(round)
        battles = Battle.where(round_id: round.id)
        scores = Scores.where(round_id: round.id)
        ghost_battle = Battles.where("first_id is null or second_id is null")
        ghost_battle.first_id.nil? ? ghost_buster = Team.find(ghost_battle.second_id) : ghost_buster = Team.find(ghost_battle.first_id)
        

        battles.each do |battle|
          first = Team.find(first_id) || nil
          second = Team.find(second_id) || nil
        end
      end
    end
  end
end
