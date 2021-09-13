# Manages how much currency the player gets each round
# there is a specific prize for that during a dispute month
class Currency < ApplicationRecord
  belongs_to :team
  belongs_to :round

  def self.save_currencies(round)
    Team.active.each do |team|
      team_score = Connection.team_score(team.id_tag, round.number)
      # Sometimes people miss some rounds and dont have a team_score
      variation = check_variation(team_score) if team_score && team_score["atletas"]
      currency = find_or_initialize_by(round: round, team: team)
      currency.difference = variation
      currency.save
    end
    true
  end

  def self.check_variation(team_score)
    team_score['atletas'].pluck('variacao_num').sum
  end

  def value
    previous_currencies = Currency.joins(:round)
                                  .where('rounds.number <= ?', round.number)
                                  .where(team_id: team_id)
                                  .where('rounds.season_id = ?', Season.active.id)
    total_difference = previous_currencies.pluck(:difference).compact.sum
    total_difference + 100
  end

  def self.difference_details(currencies)
    return [] if currencies.pluck(:difference).compact.empty?

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
      difference = currencies.pluck(:difference).compact.sum
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
  end
end
