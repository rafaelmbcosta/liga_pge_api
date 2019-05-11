module Api
  module V1
    class NewBattle
      def self.perform(round)
        unless round.finished?
          fantasma = false
          teams = Team.active.pluck(:id)
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
        BattlesReport.perform
      end
    end
  end
end
