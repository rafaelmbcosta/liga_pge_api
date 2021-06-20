module Concern::Battle::Creation
  extend ActiveSupport::Concern

  included do
    def self.create_battles(round)
      teams = Team.new_battle_teams
      raise 'cannot generate battle with ODD teams' if teams.size.odd?

      sort_battle(teams, round)
    end

    private
    def self.sort_battle(teams, round)
      until teams.empty?
        chosen_team, teams = pick_team(teams)
        battle_history = check_encounters(chosen_team, teams, round)
        lower_battle_number = lower_battle_number(battle_history)
        rival, teams = sort_rival(battle_history, lower_battle_number, teams)
        create_battle(chosen_team, rival, round)
      end
      teams
    end

    def self.sort_rival(battle_history, lower, teams)
      rivals = battle_history.select { |_rival, number| number == lower }
                             .collect { |rival, _number| rival }
      rival = rivals[rand(rivals.size)]
      teams.delete(rival)
      [rival, teams]
    end

    def self.lower_battle_number(battle_history)
      lower = 38
      battle_history.each do |_rival, number|
        lower = number if number < lower
      end
      lower
    end

    def self.pick_team(teams)
      team = teams[rand(teams.size)]
      teams.delete(team)
      [team, teams]
    end

    def self.check_encounters(team, teams, round)
      battle_history = {}
      teams.each do |rival|
        home = find_battle(round, team, rival)
        visiting = find_battle(round, rival, team)
        battle_history[rival] = home.size + visiting.size
      end
      battle_history
    end

    def self.create_battle(team, rival, round)
      team_id = team.id unless team.nil?
      rival_id = rival.id unless rival.nil?
      Battle.create(first_id: team_id, second_id: rival_id, round_id: round.id)
    end
  end
end