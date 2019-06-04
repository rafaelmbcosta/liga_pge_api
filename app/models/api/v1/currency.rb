module Api
  module V1
    class Currency < ApplicationRecord
      belongs_to :team
      belongs_to :round
    end

    def self.rounds_avaliable_to_save_currencies
      Round.rounds_avaliable_to_save_currencies
    end

    def self.check_variation(team_score)
      team_score["atletas"].pluck('variacao_num').sum
    end

    def self.save_currencies_round(round)
      Team.active.each do |team|
        team_score = Connection.team_score(team.slug, round.number)
        variation = check_variation(team_score)
        Currency.create(round: round, team: team, difference: variation)
      end
    end

    def self.dispute_month_team_details(dispute_month, teams)
      team_details = []
      teams.each do |team|
      
        difference = dispute_month.currencies.where(team: team).pluck(:difference).sum
        details = { name: team.name, player: team.player_name, difference: nil, 
                    team_symbol: team.url_escudo_png, difference_details: difference }
        # wip
      end
    end

    def self.dispute_month_information(dispute_month, teams)
      info = { name: dispute_month.name, id: dispute_month.id }
      info[:teams] = dispute_month_team_details(dispute_month, teams)
      info
    end

    def self.show_currencies
      season = Season.active #?
      teams = Team.active
      dispute_months = []
      season.dispute_months.each do |dm|
        dispute_months << dispute_month_information(dm, teams)
      end
      rescue StandardError => e
        FlowControl.create(message_type: :error, message: e)
      end
    end

    def self.save_currencies
      rounds_avaliable_to_save_currencies.each do |round|
        round.round_control.update_attributes(generating_currencies: true)
        save_currencies_round(round)
        round.round_control.update_attributes(currencies_generated: true)
      end
    rescue StandardError => e
      FlowControl.create(message_type: :error, message: e)
    end
  end
end
