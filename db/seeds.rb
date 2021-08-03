puts 'Creating teams...'

data = Connection.team_data('fla')

data.each do |team|
    Team.create!(
        name: team["nome"],
        url_escudo_png: team["url_escudo_png"],
        player_name: team["nome_cartola"],
        id_tag: team["time_id"]
    )
end

puts 'Creating disputes...'

months = ['Janeiro', 'Fevereiro', 'Março', 'Abril']

season = Season.create(year: Time.now.year)

months.each do |month|
  DisputeMonth.create!(name: month, season: season)
end

puts 'Distribute rounds among disputes...'

Round.all.find_in_batches(batch_size: 10).with_index do |rounds, index|
    dispute = DisputeMonth.find { |dispute| dispute.name === months[index] }

    rounds.each do |round|
        round.update!(dispute_month: dispute)
        puts "generating scores for round #{round.number}..."
        Team.all.each do |team|
            Score.create!(
                team: team,
                round: round,
                final_score: (rand()*100).round(2)
            )
        end
    end
end

puts 'Done...'