module Concern::Team::BattleTeams
  extend ActiveSupport::Concern

  included do
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