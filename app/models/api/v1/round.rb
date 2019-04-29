module Api
  module V1
    # Gerencia tudo o que é relacionado as rodadas
    class Round < ApplicationRecord
      belongs_to :season
      belongs_to :dispute_month
      has_many :scores
      has_many :currencies
      has_many :battles
      has_many :month_activities

      validate :more_than_two_active
      validates_uniqueness_of :number, scope: :season_id, message: 'Rodada já existente na temporada'

      default_scope { order('number asc') }

      def more_than_two_active
        errors.add(:more_than_two, 'Já exitem 2 ativos') if Season.active.active_rounds.count >= 2 &&
                                                            self.new_record?
      end

      def self.exist_round?(season, round_number)
        season.active_rounds.pluck(:number).include?(round_number)
      end

      def self.find_dispute_month(season, number)
        dispute_months = season.dispute_months
        dispute_months.to_a.find { |dm| dm.dispute_rounds.include?(number) }
      end

      def self.new_round(season, number)
        dispute_month = find_dispute_month(season, number)
        round = Round.new(season: season, dispute_month: dispute_month, number: number)
        round.save ? round : (raise 'Round já existe')
      end
      
      def self.check_new_round
        season = Season.active
        current_api_round = Connection.current_round
        raise 'Invalid current round' if current_api_round.class != Fixnum
        round_exist = exist_round?(season, current_api_round)
        return round_exist ? true : new_round(season, current_api_round)
      end

      def self.check_golden(round_number)
        Season.last.golden_rounds.include?(round_number)
      end

      def self.partials
        $redis.get("partials")
      end

      def self.partial(team)
        $redis.get("partial_#{team}")
      end

      def ghost_score
        # battle againts the ghost (null id)
        ghost_battle = Battle.find{ |b| (b.first_id.nil? or b.second_id.nil?) and b.round_id == self.id }
        # ghost buster is the player against the ghost
        ghost_battle.first_id.nil? ? ghost_buster = Team.find(ghost_battle.second_id) : ghost_buster = Team.find(ghost_battle.first_id)
        ghost_buster_score = self.scores.find{ |s| s.team_id == ghost_buster.id}.final_score
        total_scores = self.scores.select{ |s| s.team.active == true }.count - 1
        sum_scores = self.scores.select{ |s| s.team.active == true }.collect{ |sc| sc.final_score }.sum
        ghost_score = (sum_scores - ghost_buster_score)/total_scores
        return ghost_score
      end

      def ghost_partial_score
        ghost_battle = Battle.find{ |b| (b.first_id.nil? or b.second_id.nil?) and b.round_id == self.id }
        ghost_battle.first_id.nil? ? ghost_buster = Team.find(ghost_battle.second_id) : ghost_buster = Team.find(ghost_battle.first_id)
        ghost_buster_score = self.scores.find{ |s| s.team_id == ghost_buster.id }.partial_score
        total_scores = self.scores.select{ |s| s.team.active == true }.count - 1
        sum_scores = self.scores.select{ |s| s.team.active == true }.collect{ |sc| sc.partial_score }.sum
        ghost_score = (sum_scores - ghost_buster_score)/total_scores
        return ghost_score
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
        unless (players.size % 2 == 0)
          players.delete(fantasma)
        end

        while (players.size > 0) do
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
          adversarios = confrontos.select{ |k, v| v == menor }.collect{ |k, v| k }
          adversario = Player.find(adversarios[rand(adversarios.size)])
          players.delete(adversario)
          Battle.create(first_id: player.id, second_id: adversario.id, round_id: round.id)
        end
      end
    end
  end
end
