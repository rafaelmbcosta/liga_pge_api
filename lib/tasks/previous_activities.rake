desc "This task is used to insert previous awards"
task :previous_activities => :environment do
  puts "Updating activities..."
  Api::V1::DisputeMonth.where("name in ('Maio/Junho', 'Julho', 'Agosto', 'Setembro', 'Outubro')").each do |dm|
    Api::V1::Team.all.each do |team|
      unless (team.slug == "47-do-segundo-tempo-fc" && ["Agosto", "Setembro","Outubro"].include?(dm.name))
        unless (team.slug == "paysangol" && ["Maio/Junho", "Julho"].include?(dm.name))
          unless (team.slug == "chico-e-gunha-fc" && dm.name == "Maio/Junho")
            unless (team.slug == "djmss-fc")
              Api::V1::MonthActivity.create(team: team, dispute_month: dm, payed: true, active: true)
            end
          end
        end
      end
    end
  end
  puts "Done !"
  puts "Updating awards"
  (1..26).to_a.each do |number|
    round = Api::V1::Round.find{|r| r.number == number}
    Api::V1::AwardWorker.perform(round)
  end
    puts "Done"
end
