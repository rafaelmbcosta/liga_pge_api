module Api
  module V1
    # Manages how much currency the player gets each round
    # there is a specific prize for that during a dispute month
    class Currency < ApplicationRecord
      belongs_to :team
      belongs_to :round

      delegate :number, to: :round, allow_nil: false

      def value
        previous_currencies = Currency.joins(:round)
                                      .where('rounds.number <= ?', round.number)
                                      .where(team_id: team_id)
                                      .where('rounds.season_id = ?', Season.active.id)
        total_difference = previous_currencies.pluck(:difference).sum
        total_difference + 100
      end

      def self.rounds_avaliable_to_save_currencies
        Round.rounds_avaliable_to_save_currencies
      end

      def self.check_variation(team_score)
        team_score['atletas'].pluck('variacao_num').sum
      end

      def self.save_currencies_round(round)
        Team.active.each do |team|
          team_score = Connection.team_score(team.id_tag, round.number)
          variation = check_variation(team_score)
          Currency.create(round: round, team: team, difference: variation)
        end
        true
      end

      def self.difference_details(currencies)
        details = []
        currencies.each do |currency|
          details << { value: (currency.value).round(2), difference: currency.difference.round(2),
                       round: currency.round.number }
        end
        details
      end

      def self.order_team_details(team_details)
        team_details.sort_by { |team| team[:difference] }.reverse
      end

      def self.dispute_month_team_details(dispute_month, teams)
        return [] unless dispute_month.currencies.present?
        
        team_details = []
        teams.each do |team|
          currencies = dispute_month.currencies.where(team: team).order('round_id desc')
          difference = currencies.pluck(:difference).sum
          team_details << { name: team.name, player: team.player_name,
                            difference: difference.round(2),
                            team_symbol: team.url_escudo_png,
                            details: difference_details(currencies) }
        end
        order_team_details(team_details)
      end

      def self.dispute_month_information(dispute_month, teams)
        info = { name: dispute_month.name, id: dispute_month.id }
        info[:teams] = dispute_month_team_details(dispute_month, teams)
        info
      end

      def self.order_currency_report(dispute_months)
        dispute_months.sort_by! { |dm| dm[:id] }.reverse
      end

      def self.show_currencies
        season = Season.active
        teams = Team.active
        dispute_months = []
        season.dispute_months.reverse.each do |dm|
          dispute_months << dispute_month_information(dm, teams)
        end
        $redis.set('currencies', order_currency_report(dispute_months).to_json)
      rescue StandardError => e
        FlowControl.create(message_type: :error, message: e)
      end

      def self.find_and_update_currencies(round)
        Team.active.each do |team|
          team_score = Connection.team_score(team.id_tag, round.number)
          variation = check_variation(team_score)
          currency = Currency.find_by(round: round, team: team)
          currency.update_attributes(difference: variation)
        end
        true
      end

      def self.rerun_currencies
        season = Season.active
        season.rounds.each do |round|
          find_and_update_currencies(round)
        end
        true
      rescue StandardError
        FlowControl.create(message_type: :error, message: 'Erro ao rodar novamente patrimonio')
      end

      def self.save_currencies
        rounds_avaliable_to_save_currencies.each do |round|
          round.round_control.update_attributes(generating_currencies: true)
          save_currencies_round(round)
          round.round_control.update_attributes(currencies_generated: true)
        end
        true
      rescue StandardError => e
        FlowControl.create(message_type: :error, message: e)
      end
    end
  end
end
