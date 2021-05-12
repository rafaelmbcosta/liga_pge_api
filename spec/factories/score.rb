# FactoryBot.define do
#   factory :v1_score, class: ::Score do
#     player_name   { Faker::Name.name }
#     team_name     { "#{Faker::Team.name} FC" }
#     partial_score { rand(1..100).to_f }
#     final_score   { rand(1..100).to_f }
#     players       { rand(1..12).to_f + 1 }
#   end
# end
