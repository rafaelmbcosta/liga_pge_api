desc "Prepare the API while there is no ADM Front end"
task :previous_activities => :environment do
  # TODO
  # 1) get active seasons
  season = Api::V1::Season.active
  # add dispute months to season
  dm = Api::V1::DisputeMonth.create(season: season, name: 'Abril/Maio', 
                                    dispute_rounds: (1..8).to_a, price: 30.0, 
                                    finished: false)
  # 2) check active players

  # 3) create teams

  # create rounds one by one ?!
  (1..4).to_a.each do |round_number|
    round = Api::V1::Round.create(number: round_number, season: season, 
                                  dispute_month: dm, finished: true, 
                                  golden: (round.number == 4),
                                  finished: (round.number != 4))
    # Gerar batalhas

    # Calcular resultados

  end
  0
  # 5) update scores
end