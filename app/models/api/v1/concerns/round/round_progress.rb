require 'active_support/concern'

module Api
  module V1
    module Concerns
      module Round
        module RoundProgress
          extend ActiveSupport::Concern

          ORDER = [
            { attribute: :market_closed, label: 'mercado fechado' }
            { attribute: :battles_created, label: 'batalhas criadas' }
            { attribute: :scores_created, label: 'placares criados' }
            { attribute: :finished, label: 'rodada finalizada' }
            { attribute: :scores_updated, label: 'placares atualizados' }
            { attribute: :battles_updated, label: 'confrontos atualizados' }
            { attribute: :currency_created, label: 'premiação atualizada' }
            { attribute: :turns_and_championship_updated, label: 'turno atualizado' }
        ].freeze

        # { 
        #   step: 1,
        #   label: 'Mercado Fechado',
        #   value: '?'
        # }



          included do
            def self.progress
              rounds = Season.active.rounds.last(2)
              progress = []
              rounds.each do |round|
                progress << round_progress(round)
              end
              progress
            end

            def round_progress(round)
              order_array  = []
              ORDER.each do |order|
                
              end
            end
          end
        end
      end
    end
  end
end