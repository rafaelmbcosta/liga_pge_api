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

      END_OF_FIRST_HALF = 18.freeze
      BEGINNING_OF_SECOND_HALF = 19.freeze
      END_OF_SECOND_HALF = 38.freeze

      def active_rounds
        rounds.where(finished: false)
      end
    end
  end
end
