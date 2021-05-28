class Season < ApplicationRecord
  # include Concern::Season::TurnsAndChampionship
  include Concern::Season::Sync

  has_many :dispute_months, -> { order(:id) }
  has_many :rounds
  has_many :battles, through: :rounds
  has_many :scores, through: :rounds

  serialize :golden_rounds

  scope :active, -> { find_by(finished: false) }

  validates_presence_of :year

  END_OF_FIRST_HALF = 18.freeze
  BEGINNING_OF_SECOND_HALF = 19.freeze
  END_OF_SECOND_HALF = 38.freeze

  # Creates a new season with all 38 rounds without any dispute.
  def self.new_season
    raise 'Season already exist' if active.present?

    Season.transaction do
      season = create!(year: Time.now.year)
      rounds = []
      (1..38).to_a.each do |number|
        rounds << { number: number, season: season}
      end
      Round.create!(rounds)
    end
  end

  # finished rounds

  # unfinished rounds

  def active_round
    rounds.find { |round| round.active == true }
  end
end
