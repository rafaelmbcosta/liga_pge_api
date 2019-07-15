require 'active_support/concern'

module Api::V1::Concerns
  module RoundConcern
    extend ActiveSupport::Concern
  
    def field_value(field, value)
      raise 'Invalid Field' if !field.in?(ALLOWED_FIELDS)
  
      joins(:round_control).where("round_controls.#{field.to_s}" => value)
    end
  
    def avaliable_for_battles
      Round.where(finished: false).field_value(:market_closed, true)
                                  .field_value(:battles_generated, false)
                                  .field_value(:generating_battles, false)
    end
  
    def avaliable_for_score_generation
      Round.where(finished: false).field_value(:market_closed, true)
                                  .field_value(:creating_scores, false)
                                  .field_value(:scores_created, false)
  
    end
  
    def avaliable_to_be_finished
      Round.where(finished: false).field_value(:market_closed, true)
                                  .field_value(:battles_generated, true)
                                  .field_value(:scores_created, true)
    end
  
    def rounds_with_scores_to_update
      Round.where(finished: true).field_value(:scores_created, true)
                                .field_value(:scores_updated, false)
                                .field_value(:updating_scores, false)
    end
  
    def rounds_with_battles_to_update
      Round.where(finished: true).field_value(:battles_generated, true)
                                .field_value(:scores_updated, true)
                                .field_value(:updating_battle_scores, false)
                                .field_value(:battle_scores_updated, false)
    end
  
    def rounds_avaliable_to_save_currencies
      Round.where(finished: true).field_value(:battles_generated, true)
                                .field_value(:scores_updated, true)
                                .field_value(:generating_currencies, false)
                                .field_value(:currencies_generated, false)
    end
  end
end
