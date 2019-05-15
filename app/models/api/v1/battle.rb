module Api
  module V1
    class Battle < ApplicationRecord
      belongs_to :round

      def self.find_ghost_battle(round_id)
        Battle.where(round_id: round_id).select { |battle| battle.first_id.nil? || battle.second_id.nil? }
      end

      def self.list_battles
        $redis.get('battles')
      end
    end
  end
end
