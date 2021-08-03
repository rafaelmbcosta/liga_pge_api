class Team < ApplicationRecord
  include Concern::Team::Sync
  include Concern::Team::BattleTeams

  has_many :currencies
  has_many :month_activities

  validate :check_battles, on: [:disable]
  validates_uniqueness_of :id_tag, message: 'Time já cadastrado'

  scope :active, -> { where(active: true) }

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
end
