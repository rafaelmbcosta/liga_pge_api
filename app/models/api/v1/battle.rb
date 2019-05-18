module Api
  module V1
    # Generate team battles every round
    class Battle < ApplicationRecord
      belongs_to :round

      scope :find_battle, lambda { |round_id, team, other_team|
        where(round: round_id).where('first_id = ? and second_id = ?', team, other_team)
      }

      # ghost is represented by nil
      # ghost battle is the one with first or second nil id
      def self.find_ghost_battle(round_id)
        Battle.where(round_id: round_id).find { |battle| battle.first_id.nil? || battle.second_id.nil? }
      end

      def self.rounds_avaliable_for_battles
        Round.avaliable_for_battles
      end

      # find and count all previous againts other teams
      def self.check_encounters(team, teams, round)
        battle_history = {}
        teams.each do |rival|
          home = Battle.find_battle(round, team, rival)
          visiting = Battle.find_battle(round, rival, team)
          battle_history[rival] = home.size + visiting.size
        end
        battle_history
      end

      def self.lower_battle_number(battle_history)
        lower = 38
        battle_history.each do |_rival, number|
          lower = number if number < lower
        end
        lower
      end

      # pick a team among the ones with lower history
      def self.sort_rival(battle_history, lower, teams)
        rivals = battle_history.select { |_rival, number| number == lower }
                               .collect { |rival, _number| rival }
        rival = rivals[rand(rivals.size)]
        teams.delete(rival)
        [rival, teams]
      end

      def self.create_battle(team, rival, round)
        Battle.create(first_id: team, second_id: rival, round: round)
      end

      def self.pick_team(teams)
        team = teams[rand(teams.size)]
        teams.delete(team)
        [team, teams]
      end

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

      def self.generate_battles(round)
        teams = Team.new_battle_teams
        raise 'cannot generate battle with ODD teams' if teams.size.odd?

        sort_battle(teams, round)
      end

      def self.create_battles
        rounds_avaliable_for_battles.each do |round|
          generate_battles(round)
        end
        true
      rescue StandardError => e
        FlowControl.create(message_type: :error, message: e)
      end

      def self.list_battles
        $redis.get('battles')
      end
    end
  end
end
