module Api
  module V1
    # Gerencia tudo o que é relacionado as rodadas
    class Round < ApplicationRecord
      include Concerns::Round::RoundFinders
      include Concerns::Round::RoundProgress

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

      scope :valid_close_date, lambda { |date|
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

      def team_score(team_id, scores)
        return ghost_score(scores) if team_id.nil?
        score = scores.find { |score| score.team_id ==  team_id }
        score.final_score
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

      # ghost is represented by nil
      # ghost battle is the one with first or second nil id

      def find_ghost_battle
        self.battles.find { |battle| battle.first_id.nil? || battle.second_id.nil? }
      end

      # returns the score of the one facing the ghost
      def ghost_buster_score(score_type, scores)
        ghost_battle = find_ghost_battle
        ghost_buster_id = ghost_battle.first_id.nil? ? ghost_battle.second_id : ghost_battle.first_id
        ghost_buster_team = Team.find(ghost_buster_id)
        ghost_buster_score = scores.find_by(team_id: ghost_buster_team.id)
        score_type == 'partial_score' ? ghost_buster_score.partial_score : ghost_buster_score.final_score
      end

      def sum_scores(score_type, scores)
        scores.pluck(score_type.to_sym).sum
      end

      def ghost_score(scores, partial = false)
        score = partial ? 'partial_score' : 'final_score'
        total_scores = scores.count - 1
        (sum_scores(score, scores) - ghost_buster_score(score, scores)) / total_scores
      end

      def self.closed_market_routines
        BattleWorker.perform("closed_market")
        ScoresWorker.perform("closed_market")
      end

      def self.round_finished_routines
        ScoresWorker.perform('finished_round')
        BattleWorker.perform('finished_round')
        CurrencyWorker.perform
        SeasonWorker.perform("finished_round")
      end

      def self.general_tasks_routine
        RoundWorker.perform
        TeamWorker.perform
        SeasonWorker.perform("season_finished")
      end

      def self.active_round_status
        Season.active.rounds.last(2)
      end

      # Rules:
      # API market is open
      # battles are generated
      # scores are created
      # finished is false
      def self.finish_round
        avaliable_to_be_finished.to_a.each do |round|
          round.update_attributes(finished: true) if Connection.market_status['market_open']
        end
        true
      rescue StandardError => e
        FlowControl.create(message_type: :error, message: e)
      end
    end
  end
end
