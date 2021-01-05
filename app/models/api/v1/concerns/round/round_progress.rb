require 'active_support/concern'

module Api
  module V1
    module Concerns
      module Round
        module RoundProgress
          extend ActiveSupport::Concern

          ORDER = [
            { attribute: :market_closed, label: 'Mercado fechado', round: false },
            { attribute: :battles_generated, label: 'Batalhas criadas', round: false },
            { attribute: :scores_created, label: 'Placares criados', round: false },
            { attribute: :finished, label: 'Rodada finalizada', round: true },
            { attribute: :scores_updated, label: 'Placares atualizados', round: false },
            { attribute: :battle_scores_updated, label: 'Confrontos atualizados', round: false },
            { attribute: :currencies_generated, label: 'Cartoletas criadas', round: false }
          ].freeze

          included do
            # Return an array with all steps
            def self.progress_active
              rounds = Api::V1::Season.active.rounds.last(2)
              progress_collection = []
              rounds.each do |round|
                progress_hash = { progress: round.progress, number: round.number }
                progress_collection << progress_hash
              end
              progress_collection
            end

            # Check if every step is complete
            def step_complete?(step)
              return attributes.symbolize_keys[step[:attribute]] if step[:round]

              round_control.attributes.symbolize_keys[step[:attribute]]
            end

            # Organizes the progress array filling the steps
            def progress
              order_array = []
              ORDER.each_with_index do |order, i|
                order_dup = order.dup
                order_dup[:value] = step_complete?(order)
                order_dup[:step] = i + 1
                order_array << order_dup
              end
              order_array
            end
          end
        end
      end
    end
  end
end
