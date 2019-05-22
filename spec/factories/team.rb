FactoryBot.define do
  factory :v1_team, class: Api::V1::Team do
    name           { "#{Faker::Team.name} FC" }
    player_name    { "#{Faker::Name.name} FC" }
    active         { true }
  end
end
