module Api
  module V1
    class Team < ApplicationRecord
      has_many :currencies
      has_many :month_activities

      validate :check_battles, on: [:disable]
      
      scope :active, -> { where(active: true) }

      def self.activation(params)
        team = find(params[:id])
        { success: true } if team.update_attributes(active: params[:active])
      rescue StandardError => e
        { success: false, message: 'Erro ao atualizar time' }
      end
      
      def disable
        dispute_month = DisputeMonth.active
        month_activity = self.month_activities.find_by(dispute_month: dispute_month)
        month_activity.update_attributes(active: false)
        self.update_attributes(active: false)
      end
  
      def check_battles
        dispute_month = DisputeMonth.active
        battles = Battle.where("round_id in (:rounds) and (first_id = :team_id or second_id = :team_id)",
                              { team_id: self.id, rounds: dispute_month.dispute_rounds } )
        raise "Cannot disable because there is a battle with this team" if battles.present?
      end

      def self.ghost_needed?
        active.size.odd?
      end

      def self.new_battle_teams
        teams = active.to_a
        teams << nil if ghost_needed?
        teams
      end
    end
  end
end
