module Api
  module V1
    class FinalCurrency


      def self.perform(round)
        #round == 23
        previous_round = Round.find{|r| r.number == round.number - 1 and r.season == Season.last}
        Team.where(season: round.season).each do |team|
          last_currency = nil
          variation = 0
          actual_currency = 0
          #busco se tem time montado.
          team_score = Connection.team_score(team.slug, round.number)
          unless team_score["atletas"].empty?
            variation = team_score["atletas"].collect{|atleta| atleta["variacao_num"]}.sum
            previous_currency = nil
            previous_currency = Currency.find{|c| c.round_id == previous_round.id and c.team_id == team.id} unless previous_round.nil?
            previous_currency.nil? ? currency = 100 + variation : currency = previous_currency.value + variation
            Currency.create(value: currency, round_id: round.id, team: team, difference: variation)
          end
        end
      end

    end
  end
end
