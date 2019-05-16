module Api
  module V1
    class Battle < ApplicationRecord
      belongs_to :round

      scope :find_battle, ->(round_id, team, other_team){
        where(round: round_id).where('first_id = ? and second_id = ?', team, other_team)
      }

      def self.find_ghost_battle(round_id)
        Battle.where(round_id: round_id).select { |battle| battle.first_id.nil? || battle.second_id.nil? }
      end

      def self.rounds_avaliable_for_battles
        Round.avaliable_for_battles
      end

      def self.check_encounters(team, teams, battle_history, round)
        battle_history = Hash.new
        teams.each do |rival|
          home = Battle.find_battle(round, team, rival)
          visiting = Battle.find_battle(round, rival, team)
          battle_history[rival] = home.size + visiting.size
        end
        battle_history
      end

      def self.less_battle_number(battle_history)
        less = 38
        battle_history.each do |_rival, number|
          less = number if number < less
        end
        less
      end

      def self.sort_rival(battle_history, less, teams)
        rivals = battle_history.select { |_rival, number| number == less } 
                               .collect { |rival, _number| rival}
        rival = rivals[rand(rivals.size)]
        teams.delete(rival)
        return rival, teams
      end

      def create_battle(team, rival, round)
        Battle.create(first_id: team, second_id: rival, round: round)
      end

      def pick_team(teams)
        team = teams[rand(teams.size)]
        teams.delete(team)
        return team, teams
      end

      def self.sort_battle(teams, round)
        while (teams.size > 0) do
          chosen_team, teams = pick_team(teams)
          battle_history = check_encounters(chosen_team, teams, battle_history, round)
          less_battle_number = less_battle_number(battle_history)
          rival, teams = sort_rival(battle_history, less, teams)
          create_battle(chosen_team, rival, round)
        end
        teams
      end

      def self.generate_battles(round)
        teams = Team.new_battle_teams
        sort_battle(team, round)
      end

      def self.create_battles
        rounds_avaliable_for_battles.each do |round|
          generate_battles(round)
        end
      rescue StandardError => e

      end

      def self.list_battles
        $redis.get('battles')
      end
    end
  end
end
