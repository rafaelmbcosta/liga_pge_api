module Api
  module V1
    class Season < ApplicationRecord
      include Concerns::Season::TurnsAndChampionship

      has_many :dispute_months, -> { order(:id) }
      has_many :rounds
      has_many :scores, through: :rounds

      serialize :golden_rounds

      scope :active, -> { find_by(finished: false) }

      validates_presence_of :year
      validate :another_season_active?

      END_OF_FIRST_HALF = 18.freeze
      BEGINNING_OF_SECOND_HALF = 19.freeze
      END_OF_SECOND_HALF = 38.freeze

      def another_season_active?
        errors.add(:already_exist, 'Temporada já existe') if Season.active.present? &&
                                                             self.new_record?
      end

      def active_rounds
        rounds.where(finished: false)
      end
    end
  end
end
