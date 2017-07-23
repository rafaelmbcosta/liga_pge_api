module Api
  module V1
    class Round < ApplicationRecord
      belongs_to :season
      belongs_to :dispute_month


      def self.partials
        last_round = Round.last
        scores = Score.where(round: last_round).order('partial_score desc')
      end

      def self.partial(team)
        last_round = Round.last
        team_athletes = Connection.team_score(team.slug, last_round.number)
        athletes = Connection.athletes_scores
        result = []
        team_athletes["atletas"].each do |team_athlete|
          partial = Hash.new
          partial["nickname"] = team_athlete["apelido"]
          partial["points"] = "-"
          partial["scouts"] = "-"
          partial["team"] = team_athletes["clubes"][team_athlete["clube_id"].to_s]["abreviacao"]
          partial["team_logo"] = team_athletes["clubes"][team_athlete["clube_id"].to_s]["escudos"]["45x45"]
          athlete_id = team_athlete["atleta_id"].to_s
          if athletes["atletas"].include?(athlete_id)
            partial["points"] = athletes["atletas"][athlete_id.to_s]["pontuacao"]
            scouts = athletes["atletas"][athlete_id.to_s]["scout"]
            partial["scouts"] = scouts.collect{|k,v| "#{k}x#{v}"}.join(" ").gsub("x1","")
          end
          result << partial
        end
        return result
      end

      def self.battle_generator
        fantasma = Player.where("name = 'Fantasma'").first
        round = Round.new
        last_round = Round.last
        round.number = last_round.number + 1
        round.season_id = Season.last.id
        round.date = Time.now
        round.save

        players = Player.where("active is true").to_a
        unless ( players.size % 2 == 0 )
          players.delete(fantasma)
        end

        while ( players.size > 0 ) do
          player = players[rand(players.size)]
          # Comparo o player com todos os outros players
          confrontos = Hash.new
          players.delete(player)
          players.each do |rival|
            home = Battle.where("first_id = ? and second_id = ?", player.id, rival.id)
            visiting = Battle.where("first_id = ? and second_id = ?", rival.id, player.id)
            confrontos[rival.id] = home.size + visiting.size
          end

          #descobre os que tem menos jogos
          menor = 10
          confrontos.each do |k, v|
            menor = v if v < menor
          end
          #agora pega os que tem menos jogos
          adversarios = confrontos.select{|k,v| v == menor }.collect{|k, v| k}
          adversario = Player.find(adversarios[rand(adversarios.size)])
          players.delete(adversario)
          Battle.create(first_id: player.id, second_id: adversario.id, round_id: round.id )
        end
      end
    end
  end
end
