class Season < ApplicationRecord
  has_many :dispute_months, -> { order(:id) }
  has_many :rounds
  has_many :battles, through: :rounds
  has_many :scores, through: :rounds

  scope :active, -> { find_by(finished: false) }

  validate :only_one_active
  validates_presence_of :year

  after_create :create_rounds

  def only_one_active
    raise 'Season already exist' if Season.active.present?
  end

  def self.new_season
    create!(year: Time.now.year)
  end

  def create_rounds
    rounds = []
    (1..38).to_a.each do |number|
      rounds << { number: number, season: self}
    end
    Round.create!(rounds)
  end
end
