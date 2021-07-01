# Gerencia tudo o que é relacionado as rodadas
class Round < ApplicationRecord
  include Concern::Round::CheckNewRound
  include Concern::Round::CloseMarket
  include Concern::Round::Routines

  belongs_to :season
  belongs_to :dispute_month, optional: true
  has_many :scores
  has_many :currencies
  has_many :battles
  has_many :month_activities
  validates_uniqueness_of :number, scope: :season_id, message: 'Rodada já existente na temporada'

  default_scope { order('number asc') }

  after_update do
    finish_previous_round if saved_changes.dig('active', 1) == true
    Round.closed_market_routines(self) if saved_changes.dig('market_closed', 1) == true
    Round.round_finished_routines(self) if saved_changes.dig('finished', 1) == true
  end

  def self.active
    Season.active.rounds.find { |round| round.active }
  end

  def status
    return 'active' if active

    return 'finished' if finished

    'created'
  end

  def self.get_by_number(number)
    Season.active.rounds.find { |round| round.number == number }
  end

  def previous_round
    season.rounds.find { |round| round.number == number - 1 }
  end
end
