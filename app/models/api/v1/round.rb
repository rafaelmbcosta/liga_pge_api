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
      has_one  :round_control

      validate :more_than_two_active
      validates_uniqueness_of :number, scope: :season_id, message: 'Rodada já existente na temporada'

      default_scope { order('number asc') }

      scope :valid_close_date, ->(date) {
        where('? >= market_close', date)
      }

      def self.current
        Season.active.rounds.max(&:number)
      end

      def self.active
        Season.active.rounds.where(finished: false)
      end

      # Rules:
      # market must be open
      # round must not be finished
      # round close date must be higher than api data
      # round must not be already closed
      def self.rounds_allowed_to_generate_battles
        market_status = Connection.market_status
        return [] unless market_status['market_closed']

        api_number = market_status['rodada_atual']
        rounds = active.where(number: api_number).valid_close_date(DateTime.now)
        rounds.reject { |round| round.round_control.market_closed }
      end

      def self.update_market_status(rounds)
        rounds.each do |round|
          round.round_control.update_attributes(market_closed: true)
        end
        true
      end

      def self.close_market
        update_market_status(rounds_allowed_to_generate_battles)
      rescue StandardError => e
        FlowControl.create(message_type: :error, message: e)
      end

      def more_than_two_active
        errors.add(:more_than_two, 'Já exitem 2 ativos') if Season.active.active_rounds.count >= 2 &&
                                                            new_record?
      end

      def self.exist_round?(season, round_number)
        season.active_rounds.pluck(:number).include?(round_number)
      end

      def self.find_dispute_month(season, number)
        dispute_months = season.dispute_months
        dispute_months.to_a.find { |dm| dm.dispute_rounds.include?(number) }
      end

      def self.new_round(season, market)
        dispute_month = find_dispute_month(season, market['rodada_atual'])
        round = Round.new(season: season, dispute_month: dispute_month,
                          number: market['rodada_atual'], market_close: market['close_date'])
        round.save ? RoundControl.create(round: round) : (raise round.errors.messages.inspect)
        round
      end

      def self.check_new_round
        season = Season.active
        market_status = Connection.market_status
        raise 'Erro: mercado invalido / fechado' if market_status.nil? || market_status['status_mercado'] != 1

        raise 'Rodada já existente' if exist_round?(season, market_status['rodada_atual'])

        new_round(season, market_status)
      rescue StandardError => e
        FlowControl.create(message_type: :error, message: e)
      end

      def self.check_golden(round_number)
        Season.last.golden_rounds.include?(round_number)
      end

      def self.partials
        $redis.get('partials')
      end

      def self.partial(team)
        $redis.get("partial_#{team}")
      end

      def ghost_buster_score(score)
        ghost_battle = Battle.find_ghost_battle(id)
        ghost_buster_id = ghost_battle.first_id.nil? ? ghost_battle.second_id : ghost_battle.first_id
        ghost_buster_team = Team.find(ghost_buster_id)
        ghost_buster_score = scores.find_by(team_id: ghost_buster_team.id)
        score == 'partial_score' ? ghost_buster_score.partial_score : ghost_buster_score.final_score
      end

      def sum_scores(score)
        scores.pluck(score.to_sym).joins(:team).where(active: true).sum
      end

      def ghost_score(partial = false)
        score = partial ? 'partial_score' : 'final_score'
        total_scores = scores.select { |s| s.team.active == true } .count - 1
        (sum_scores(score) - ghost_buster_score(score)) / total_scores
      end
    end
  end
end
