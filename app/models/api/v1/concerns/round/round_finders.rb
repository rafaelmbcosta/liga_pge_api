require 'active_support/concern'

module Api
  module V1
    module Concerns
      module Round
        module RoundFinders
          extend ActiveSupport::Concern

          ALLOWED_FIELDS = %i[ market_closed generating_battles battles_generated
            creating_scores scores_created scores_updated updating_scores
            updating_battle_scores battle_scores_updated generating_currencies
            currencies_generated
          ].freeze

          included do
            def self.field_value(field, value)
              raise 'Invalid Field' if !field.in?(ALLOWED_FIELDS)

              joins(:round_control).where("round_controls.#{field.to_s}" => value)
            end

            def self.current_season_finder
              where(season: Api::V1::Season.active)
            end

            def self.avaliable_for_battles
              where(finished: false).field_value(:market_closed, true)
                                    .field_value(:battles_generated, false)
                                    .field_value(:generating_battles, false)
            end

            def self.avaliable_for_score_generation
              where(finished: false).field_value(:market_closed, true)
                                    .field_value(:creating_scores, false)
                                    .field_value(:scores_created, false)

            end

            def self.avaliable_to_be_finished
              where(finished: false).field_value(:market_closed, true)
                                    .field_value(:battles_generated, true)
                                    .field_value(:scores_created, true)
            end

            def self.rounds_with_scores_to_update
              where(finished: true).field_value(:scores_created, true)
                                   .field_value(:scores_updated, false)
                                   .field_value(:updating_scores, false)
            end

            def self.rounds_with_battles_to_update
              current_season_finder.where(finished: true)
                                   .field_value(:battles_generated, true)
                                   .field_value(:scores_updated, true)
                                   .field_value(:updating_battle_scores, false)
                                   .field_value(:battle_scores_updated, false)

            end

            def self.rounds_avaliable_to_save_currencies
              current_season_finder.where(finished: true)
                                   .field_value(:battles_generated, true)
                                   .field_value(:scores_updated, true)
                                   .field_value(:generating_currencies, false)
                                   .field_value(:currencies_generated, false)
            end

            def self.season_finished_rounds(dispute_month_only)
              if dispute_month_only == true
                return ::Api::V1::DisputeMonth.active.rounds.where(finished: true)
              else
                return ::Api::V1::Season.active.rounds.where(finished: true)
              end
            end
          end
        end
      end
    end
  end
end
