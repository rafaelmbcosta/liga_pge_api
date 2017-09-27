desc "This task is used to insert previous awards"
task :previous_activities => :environment do
  puts "Updating activities..."
  Api::V1::DisputeMonth.where("name in ('Maio/Junho', 'Julho', 'Agosto', 'Setembro', 'Outubro')").each do |dm|
    Api::V1::Team.all.each do |team|
      unless (team.slug == "47-do-segundo-tempo-fc" && ["Agosto", "Setembro","Outubro"].include?(dm.name))
        unless (team.slug == "paysangol" && ["Maio/Junho", "Julho"].include?(dm.name))
          Api::V1::MonthActivity.create(team: team, dispute_month: dm, payed: true, active: true)
        end
      end
    end
  end
  puts "Done !"
end
