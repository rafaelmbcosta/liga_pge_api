module Api
  module V1
    class Battle < ApplicationRecord
      belongs_to :round

      def self.find_ghost_battle(round_id)
        Battle.where(round_id: round_id).select { |battle| battle.first_id.nil? || battle.second_id.nil? }
      end

      def self.rounds_avaliable_for_battles
        Round.avaliable_for_battles
      end



      def self.generate_battles(round)
        # bloco só para saber se teremos ou nao fantasma
        # teams = Team.active.pluck(:id)
        ghost = Team.ghost_needed?
        teams = Team.new_battle_teams

        fantasma = false
        if !(teams.size % 2 == 0)
          fantasma = true
          teams << nil
        end

        while (teams.size > 0) do
          team = teams[rand(teams.size)]
          # Comparo o player com todos os outros players
          confrontos = Hash.new
          teams.delete(team)
          teams.each do |rival|
            home = Battle.where("first_id = ? and second_id = ?", team, rival)
            visiting = Battle.where("first_id = ? and second_id = ?", rival, team)
            confrontos[rival] = home.size + visiting.size
          end

          #descobre os que tem menos jogos
          menor = 38
          confrontos.each do |k, v|
            menor = v if v < menor
          end
          # agora pega os que tem menos jogos
          adversarios = confrontos.select{|k,v| v == menor }.collect{|k, v| k}
          adversario = adversarios[rand(adversarios.size)]
          teams.delete(adversario)
          Battle.create(first_id: team, second_id: adversario, round_id: round.id )
        end
      end

      def self.create_battles
        rounds_avaliable_for_battles.each do |round|
          generate_battles(round)
        end
      rescue StandardError => e

      end

      def self.list_battles
        $redis.get('battles')
      end
    end
  end
end
