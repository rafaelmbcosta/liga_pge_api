class DisputeMonth < ApplicationRecord
  include Concern::DisputeMonth::Sync

  belongs_to :season
  has_many :rounds
  has_many :scores, through: :rounds
  has_many :battles, through: :rounds
  has_many :month_activities
  has_many :currencies, through: :rounds
  serialize :dispute_rounds

  def self.scores
    $redis.get("scores")
  end

  def active_players
    self.month_activities.where(active: true)
  end

  def self.battle_points
    $redis.get("league")
  end

  def self.active?
    rounds.where(active: true).any?
  end

  def self.active_rounds
    active_season = Season.active
    raise SeasonErrors::NoActiveSeasonError if active_season.nil?
  end
end
